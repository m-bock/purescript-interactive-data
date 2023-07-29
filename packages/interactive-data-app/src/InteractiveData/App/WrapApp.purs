module InteractiveData.App.WrapApp
  ( AppMsg
  , AppState
  , SelfMsg(..)
  , wrapApp
  ) where

import Prelude

import Data.Array.NonEmpty as NEA
import Data.Either (either)
import Data.Map (Map)
import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Data.These (These(..))
import Data.Tuple.Nested (type (/\), (/\))
import DataMVC.Types (DataPath, DataPathSegment, DataResult, DataUI(..), DataUiItf(..))
import DataMVC.Types.DataUI (applyWrap, runDataUi)
import InteractiveData.App.UI.Body as UI.Body
import InteractiveData.App.UI.Footer as UI.Footer
import InteractiveData.App.UI.Header as UI.Header
import InteractiveData.App.UI.Layout as UI.Layout
import InteractiveData.App.UI.Menu as UI.Menu
import InteractiveData.App.UI.Menu.Types (sumTree)
import InteractiveData.App.UI.NotFound as UI.NotFound
import InteractiveData.Core
  ( class IDHtml
  , DataTree(..)
  , DataTreeChildren(..)
  , IDOutMsg(..)
  , IDSurface(..)
  , TreeMeta
  , ViewMode(..)
  , IDViewCtx
  )
import InteractiveData.Core.Types.DataPathExtra (dataPathFromStrings, dataPathToStrings)
import InteractiveData.Core.Types.DataTree as DT
import InteractiveData.Core.Types.IDDataUI (runIdSurface)
import VirtualDOM as VD
import VirtualDOM.Transformers.Ctx.Class (class Ctx, putCtx, withCtx)
import VirtualDOM.Transformers.OutMsg.Class (runOutMsg)
import VirtualDOM.Transformers.TreeAccum.Trans (Tree)

newtype AppState sta = AppState
  { selectedPath :: Array String
  , menu :: UI.Menu.MenuState
  , dataState :: sta
  , ignore :: Boolean
  , showMenu :: Boolean
  , showErrors :: Boolean
  }

type AppMsg msg = These (SelfMsg msg) IDOutMsg

data SelfMsg msg
  = SetSelectedPath (Array String)
  | DataMsg msg
  | MenuMsg (UI.Menu.MenuMsg (SelfMsg msg))
  | SetShowMenu Boolean
  | SetShowErrors Boolean
  | NoOp

type Menu = Map DataPath { expanded :: Boolean }

type WithState sta r = (state :: AppState sta | r)

type WithTree r = (tree :: Tree (DataPathSegment /\ { isValid :: Boolean }) | r)

viewNavigationWrapper
  :: forall html msg sta
   . Ctx IDViewCtx html
  => IDHtml html
  => (sta -> DataTree html msg)
  -> AppState sta
  -> DataTree html (AppMsg msg)
viewNavigationWrapper view' state@(AppState { selectedPath }) =
  let

    view = case viewNavigationWrapper' view' state of
      Nothing ->
        UI.Layout.viewLayout
          { viewHeader: VD.noHtml
          , viewBody:
              UI.NotFound.viewNotFound
                { label: "not found"
                , path: selectedPath
                , onBackToHome: This $ SetSelectedPath mempty
                }
          , viewSidebar: Nothing
          , viewFooter: Nothing
          }
      Just tree -> tree

  in

    DataTree
      { view
      , actions: []
      , children: Fields []
      , meta: Nothing
      }

viewNavigationWrapper'
  :: forall html msg sta
   . Ctx IDViewCtx html
  => IDHtml html
  => (sta -> DataTree html msg)
  -> AppState sta
  -> Maybe (html (AppMsg msg))
viewNavigationWrapper' view' (AppState { showErrors, dataState, selectedPath, menu, showMenu }) = do
  let
    globalDataTree = view' dataState

  dataPath :: Array DataPathSegment <-
    dataPathFromStrings selectedPath globalDataTree

  selectedDataTree :: DataTree html msg <-
    DT.find dataPath globalDataTree

  dataPathWithMeta :: Array (DataPathSegment /\ TreeMeta) <-
    DT.mapMetadataAlongPath dataPath globalDataTree

  globalMeta <- globalDataTree # un DataTree # _.meta

  selectedMeta <- selectedDataTree # un DataTree # _.meta

  let
    ui =
      { menu: UI.Menu.viewMenu
      }

    header :: html (SelfMsg msg)
    header =
      UI.Header.viewHeader
        { dataPath
        , onSelectPath: SetSelectedPath <<< dataPathToStrings
        , showMenu
        , onSetShowMenu: SetShowMenu
        , typeName: selectedMeta.typeName
        }

  tree <- sumTree globalDataTree <#> _.tree

  let
    sidebar :: Maybe (html (SelfMsg msg))
    sidebar =
      if showMenu then
        Just $ map MenuMsg $
          ui.menu
            { onSelectPath: SetSelectedPath
            , tree
            }
            menu
      else Nothing

    body :: html (SelfMsg msg)
    body = UI.Body.viewBody
      { viewContent: selectedDataTree # un DataTree # _.view # map DataMsg }


    footer :: Maybe (html (SelfMsg msg))
    footer = Just $
      UI.Footer.viewFooter
        { errors: either NEA.toArray (\_ -> []) globalMeta.errored
        , onSelectPath: SetSelectedPath <<< dataPathToStrings
        , isExpanded: showErrors
        , onChangeIsExpanded: SetShowErrors
        }

  pure $
    withCtx \(ctx :: IDViewCtx) ->
      let

        viewCtx :: IDViewCtx
        viewCtx =
          ctx
            { path = dataPath
            , selectedPath = dataPath
            , viewMode = Standalone
            }
      in

        runOutMsg
          $ putCtx viewCtx
          $ UI.Layout.viewLayout
              { viewHeader: header
              , viewSidebar: sidebar
              , viewBody: body
              , viewFooter: footer
              }

update :: forall msg sta. (msg -> sta -> sta) -> AppMsg msg -> AppState sta -> AppState sta
update update' msg_ state_ = case msg_ of
  This msg -> updateThis msg state_
  That outMsg -> updateThat outMsg state_
  Both msg outMsg -> state_
    # updateThat outMsg
    # updateThis msg
  where

  updateThis msg st@(AppState state) = case msg of
    SetSelectedPath path -> AppState state { selectedPath = path }
    DataMsg msg' -> AppState state { dataState = update' msg' state.dataState }
    MenuMsg msg' -> st
      #
        f
          (\msg'' (AppState st') -> AppState st' { menu = UI.Menu.updateMenu msg'' st'.menu })
          (\msg' -> update update' (This msg'))
          msg'
    NoOp -> st
    SetShowMenu showMenu -> AppState state { showMenu = showMenu }
    SetShowErrors showErrors -> AppState state { showErrors = showErrors }

  updateThat outMsg st@(AppState state) =
    case outMsg of
      GlobalSelectDataPath path -> AppState state { selectedPath = path }

f :: forall a b z. (a -> (z -> z)) -> (b -> (z -> z)) -> These a b -> (z -> z)
f f1 f2 = case _ of
  This x -> f1 x
  That y -> f2 y
  Both x y -> f1 x >>> f2 y

init :: forall sta a. (Maybe a -> sta) -> Maybe a -> AppState sta
init init' opt = AppState
  { selectedPath: []
  , dataState: init' opt
  , menu: UI.Menu.initMenu
  , ignore: false
  , showMenu: false
  , showErrors: false
  }

extract :: forall sta a. (sta -> DataResult a) -> AppState sta -> DataResult a
extract extract' (AppState { dataState }) = extract' dataState

wrapApp
  :: forall html fm fs msg sta a
   . Ctx IDViewCtx html
  => IDHtml html
  => DataUI (IDSurface html) fm fs msg sta a
  -> DataUI (IDSurface html) fm fs (AppMsg (fm msg)) (AppState (fs sta)) a
wrapApp dataUi' =
  DataUI \ctx ->
    let
      dataUi'' = applyWrap dataUi'
      DataUiItf itf = runDataUi dataUi'' ctx

      view :: AppState (fs sta) -> IDSurface html (These (SelfMsg (fm msg)) IDOutMsg)
      view state = IDSurface \idSurfaceCtx ->
        viewNavigationWrapper
          (itf.view >>> runIdSurface idSurfaceCtx)
          state
    in
      DataUiItf
        { name: itf.name
        , view
        , update: update itf.update
        , init: init itf.init
        , extract: extract itf.extract
        }
