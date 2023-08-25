module InteractiveData.App.WrapData
  ( WrapMsg(..)
  , WrapState(..)
  , dataUiCtx
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Chameleon.Transformers.OutMsg.Class (fromOutHtml)
import Data.Array (mapMaybe)
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NEA
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
  , text :: Maybe String
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

viewStandalone :: forall html msg. IDHtml html => ViewDataCfg html msg -> html msg
viewStandalone { viewContent, actions, typeName, text } =
  withCtx \(ctx :: IDViewCtx) ->
    let
      el =
        { data_: styleNode C.div
            [ case ctx.viewMode of
                Inline ->
                  "background-color: #f8f8f8"
                Standalone ->
                  "background-color: white"
            , "margin-bottom: 5px"
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
              , "align-items: center"
              , "justify-content: space-between"
              ]
        , typeName: styleNode C.div
            [ "font-size: 20px"
            , "grid-area: b"
            , "font-weight: bold"
            , "margin-bottom: 3px"
            ]
        , text: styleNode C.div
            [ "font-size: 11px"
            ]

        , header: styleNode C.div
            [ "margin-bottom: 20px"
            ]
        }
    in
      el.data_
        []
        [ el.header []
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
            , text # maybe C.noHtml \text' -> el.item []
                [ el.text []
                    [ C.text text' ]
                ]
            ]

        , el.item [] <<< pure $ el.content []
            [ viewContent ]
        ]

viewInline :: forall html msg. IDHtml html => ViewDataCfg html msg -> html msg
viewInline { viewContent, typeName, text, error } =
  withCtx \ctx ->
    let
      el =
        { typeRow: styleNode C.div
            [ "display: flex"
            , "flex-direction: column"
            , "height: 100%"
            , "gap: 3px"
            , "margin-bottom: 5px"
            ]
        , text: styleNode C.div
            [ "font-size: 11px"
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
            [ "min-height: 130px"
            , "min-width: 120px"
            , "display: grid"
            ]
        , content: styleNode C.div
            [ ""
            ]
        , errors: styleNode C.div
            [ "color: red"
            , "display: flex"
            , "flex-direction: column"
            , "gap: 3px"
            ]
        , error: styleNode C.div
            [ "font-size: 11px" ]
        }

      filteredErrors :: Array DataErrorCase
      filteredErrors =
        error
          # either NEA.toArray (const [])
          # mapMaybe
              ( \(DataError path errorCase) ->
                  if predPath path then Just errorCase
                  else Nothing
              )

      predPath :: DataPath -> Boolean
      predPath dataPath = dataPath == []

      showErrors :: Boolean
      showErrors =
        Array.length filteredErrors > 0

      typeRow :: html msg
      typeRow =
        el.typeRow []
          [ el.typeName []
              [ C.text typeName ]
          , case text of
              Just text' ->
                el.text []
                  [ C.text text' ]
              Nothing ->
                C.noHtml
          ]

    in
      el.root []
        [ UICard.view
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
              , viewBody = Just $ C.div []
                  [ el.content []
                      [ viewContent ]
                  ]
              , viewFooter =
                  if showErrors then
                    Just $
                      el.errors []
                        ( filteredErrors
                            # map \error' ->
                                el.error []
                                  [ C.text $ printErrorCase error' ]
                        )
                  else
                    Nothing

              }
        ]

type ViewCfgStatic sta a =
  { name :: String
  , extract :: sta -> DataResult a
  }

type ViewCfgDynamic html msg sta =
  { actions :: Array (DataAction msg)
  , viewInner :: sta -> html msg
  , text :: Maybe String
  }

view
  :: forall html msg sta a
   . IDHtml html
  => ViewCfgStatic sta a
  -> ViewCfgDynamic html msg sta
  -> WrapState sta
  -> html (WrapMsg msg)
view cfgStatic cfgDynamic@{ viewInner, text } (WrapState { childState }) =
  withCtx \(ctx :: IDViewCtx) ->
    let
      rootLabel :: String
      rootLabel = fst ctx.root

      label :: String
      label = maybe rootLabel segmentToString $ Array.last ctx.path

      extractResult :: DataResult a
      extractResult = cfgStatic.extract childState

      cfg :: ViewDataCfg html msg
      cfg =
        { label: label
        , typeName: cfgStatic.name
        , viewContent: viewInner childState
        , actions: cfgDynamic.actions
        , error: map (const unit) extractResult
        , text: text
        }
    in
      map ChildMsg
        case ctx.viewMode of
          Inline ->
            viewInline cfg
          Standalone ->
            viewStandalone cfg

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
--- DataUI Interface
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
    DataTree { actions, children, text } = viewInner childState

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
          , text
          }
          state
      , children: children'
      , actions: map ChildMsg <$> actions
      , meta: Just meta
      , text
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
        { viewHtml: view
            { name: itf.name
            , extract: itf.extract
            }
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

--------------------------------------------------------------------------------
--- Util
--------------------------------------------------------------------------------

printErrorCase :: DataErrorCase -> String
printErrorCase = case _ of
  DataErrNotYetDefined -> "Value not yet defined"
  DataErrMsg msg -> msg