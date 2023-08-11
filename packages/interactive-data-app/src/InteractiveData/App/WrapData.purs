module InteractiveData.App.WrapData
  ( WrapMsg(..)
  , WrapState(..)
  , dataUiCtx
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Chameleon.Transformers.OutMsg.Class (fromOutHtml)
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Tuple (fst)
import InteractiveData.App.UI.ActionButton as UIActionButton
import InteractiveData.App.UI.Card as UICard
import InteractiveData.App.UI.DataLabel as UIDataLabel
import InteractiveData.Core.Types.DataPathExtra (dataPathToStrings, segmentToString)
import InteractiveData.Core.Types.IDSurface (runIdSurface)

--------------------------------------------------------------------------------
--- Types
--------------------------------------------------------------------------------

newtype WrapState sta = WrapState
  { childState :: sta }

data WrapMsg msg = ChildMsg msg

type ViewDataCfg (html :: Type -> Type) msg =
  { label :: String
  , typeName :: String
  , viewContent :: html msg
  , actions :: Array (DataAction msg)
  , error :: Either (NonEmptyArray DataError) Unit
  }

--------------------------------------------------------------------------------
--- Instances
--------------------------------------------------------------------------------

derive instance Eq sta => Eq (WrapState sta)
derive instance Eq msg => Eq (WrapMsg msg)

derive instance Generic (WrapState sta) _
derive instance Generic (WrapMsg msg) _

instance Show sta => Show (WrapState sta) where
  show = genericShow

instance Show msg => Show (WrapMsg msg) where
  show = genericShow

--------------------------------------------------------------------------------
--- View
--------------------------------------------------------------------------------

viewData :: forall html msg. IDHtml html => ViewDataCfg html msg -> html msg
viewData cfg =
  withCtx \ctx ->
    case ctx.viewMode of
      Inline ->
        viewInline cfg
      Standalone ->
        viewStandalone cfg

viewStandalone :: forall html msg. IDHtml html => ViewDataCfg html msg -> html msg
viewStandalone { viewContent, actions, typeName } =
  withCtx \(ctx :: IDViewCtx) ->
    let
      el =
        { data_: styleNode C.div
            [ case ctx.viewMode of
                Inline ->
                  "background-color: #f8f8f8"
                Standalone ->
                  "background-color: white"
            , "margin-bottom: 20px"
            , "position: relative"
            , "border-radius: 5px"
            , "padding-bottom: 5px"
            , "padding-top: 10px"
            , case ctx.viewMode of
                Inline ->
                  "border: 1px solid #ddd"
                Standalone ->
                  mempty
            ]
        , content: C.div
        , actions:
            styleNode C.div
              [ "display: flex" ]
        , item:
            styleNode C.div
              case ctx.viewMode of
                Inline ->
                  [ "padding-left: 10px"
                  , "padding-right: 10px"
                  ]
                Standalone -> []

        , subRow:
            styleNode C.div
              [ "display: flex"
              , "margin-bottom: 10px"
              , "align-items: center"
              , "justify-content: space-between"
              ]
        , typeName: styleNode C.div
            [ "font-size: 20px"
            , "grid-area: b"
            ]
        }

    in
      el.data_
        []
        [ el.item []
            [ el.subRow []
                [ el.typeName [] [ C.text typeName ]
                , el.actions []
                    ( map
                        (\dataAction -> UIActionButton.view { dataAction })
                        actions
                    )
                ]
            ]

        , el.item [] <<< pure $ el.content []
            [ viewContent ]
        ]

viewInline :: forall html msg. IDHtml html => ViewDataCfg html msg -> html msg
viewInline { viewContent, typeName } =
  withCtx \ctx ->
    let
      el =
        { typeRow: styleNode C.div
            [ "display: flex"
            , "align-items: center"
            , "justify-content: space-between"
            , "height: 100%"
            ]
        , caption: styleNode C.div
            [ "display: flex"
            , "align-items: center"
            , "justify-content: space-between"
            , "height: 100%"
            ]
        , typeName: styleNode C.div
            [ "font-size: 13px"
            , "margin-right: 10px"
            , "font-weight: bold"
            ]
        , root: styleNode C.div
            [ "min-height: 120px"
            , "min-width: 120px"
            , "display: grid"
            ]
        }

      typeRow :: html msg
      typeRow =
        el.typeRow []
          [ el.typeName []
              [ C.text typeName ]
          ]

    in
      el.root []
        [ UICard.view
            { viewBody: viewContent
            }
            UICard.defaultViewOpt
              { viewCaption = Just
                  $ fromOutHtml
                  $ el.caption []
                      [ UIDataLabel.view
                          { dataPath: { before: [], path: ctx.path }
                          , mkTitle: UIDataLabel.mkTitleGoto
                          }
                          { onHit: Just (That $ GlobalSelectDataPath $ dataPathToStrings ctx.path)
                          , size: UIDataLabel.Large
                          }
                      ]
              , viewSubCaption = Just typeRow
              }
        ]

type ViewCfgStatic sta a =
  { name :: String
  , extract :: sta -> DataResult a
  }

type ViewCfgDynamic html msg sta =
  { actions :: Array (DataAction msg)
  , viewInner :: sta -> html msg
  }

view
  :: forall html msg sta a
   . IDHtml html
  => ViewCfgStatic sta a
  -> ViewCfgDynamic html msg sta
  -> WrapState sta
  -> html (WrapMsg msg)
view cfgStatic cfgDynamic@{ viewInner } (WrapState { childState }) =
  withCtx \(ctx :: IDViewCtx) ->
    let
      rootLabel :: String
      rootLabel = fst ctx.root

      label :: String
      label = maybe rootLabel segmentToString $ Array.last ctx.path

      extractResult :: DataResult a
      extractResult = cfgStatic.extract childState

    in
      map ChildMsg $ viewData
        { label: label
        , typeName: cfgStatic.name
        , viewContent: viewInner childState
        , actions: cfgDynamic.actions
        , error: map (const unit) extractResult
        }

--------------------------------------------------------------------------------
--- Update
--------------------------------------------------------------------------------

update
  :: forall msg sta
   . (msg -> sta -> sta)
  -> WrapMsg msg
  -> WrapState sta
  -> WrapState sta
update update' msg (WrapState sta) = WrapState case msg of
  ChildMsg childMsg -> sta
    { childState = update' childMsg sta.childState
    }

--------------------------------------------------------------------------------
--- Extract
--------------------------------------------------------------------------------

extract
  :: forall sta a
   . (sta -> DataResult a)
  -> WrapState sta
  -> DataResult a
extract ext (WrapState state) = ext state.childState

--------------------------------------------------------------------------------
--- Init
--------------------------------------------------------------------------------

init :: forall sta a. (Maybe a -> sta) -> Maybe a -> (WrapState sta)
init ini opta = WrapState
  { childState: ini opta
  }

--------------------------------------------------------------------------------
--- DataUI Inteface
--------------------------------------------------------------------------------

type ViewDataTreeCfg html msg sta a =
  { viewHtml ::
      ViewCfgDynamic html msg sta -> WrapState sta -> html (WrapMsg msg)
  , viewInner ::
      sta -> DataTree html msg
  , extract ::
      sta -> DataResult a
  , typeName :: String
  , path :: DataPath
  }

viewDataTree
  :: forall sta html msg a
   . IDHtml html
  => ViewDataTreeCfg html msg sta a
  -> WrapState sta
  -> DataTree html (WrapMsg msg)
viewDataTree { viewInner, viewHtml, extract: extract', typeName } state@(WrapState { childState }) =
  let
    DataTree { actions, children } = viewInner childState

    extractResult :: DataResult a
    extractResult = extract' childState

    -- Important!
    -- If meta is not set here, the app is useless.
    meta :: TreeMeta
    meta =
      { errored: map (const unit) extractResult
      , typeName
      }

    children' :: DataTreeChildren html (WrapMsg msg)
    children' = map ChildMsg $ children

  in
    DataTree
      { view: viewHtml
          { actions
          , viewInner: viewInner >>> un DataTree >>> _.view
          }
          state
      , children: children'
      , actions: map ChildMsg <$> actions
      , meta: Just meta
      }

dataUiInterface
  :: forall html msg sta a
   . IDHtml html
  => DataUiInterface (IDSurface html) msg sta a
  -> DataUiInterface (IDSurface html) (WrapMsg msg) (WrapState sta) a
dataUiInterface (DataUiInterface itf) = DataUiInterface
  { name: itf.name
  , view: \state -> IDSurface \(ctx :: IDSurfaceCtx) ->
      viewDataTree
        { viewHtml: view { name: itf.name, extract: itf.extract }
        , viewInner: itf.view >>> runIdSurface ctx
        , extract: itf.extract
        , typeName: itf.name
        , path: ctx.path
        }
        state
  , extract: extract itf.extract
  , update: update itf.update
  , init: init itf.init
  }

--------------------------------------------------------------------------------
--- DataUI Ctx
--------------------------------------------------------------------------------

dataUiCtx
  :: forall html
   . IDHtml html
  => DataUICtx (IDSurface html) WrapMsg WrapState
dataUiCtx = DataUICtx { wrap: dataUiInterface }