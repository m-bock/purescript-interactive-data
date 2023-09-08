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
  , text :: Maybe String
  , filteredErrors :: Array DataErrorCase
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
viewStandalone { viewContent, actions, typeName, text, filteredErrors } =
  withCtx \(ctx :: IDViewCtx) ->
    let
      el = styleElems "InteractiveData.App.WrapData#viewStandalone"
        { data_: C.div
            /\ case ctx.viewMode of
              Inline ->
                [ "background-color: #f8f8f8"
                , "border: 1px solid #ddd"
                ]
              Standalone ->
                [ "background-color: white" ]
            /\
              [ "position: relative"
              , "border-radius: 5px"
              , "padding-bottom: 5px"
              , "padding-top: 10px"
              ]
        , content: C.div

        , actions:
            C.div /\
              [ "display: flex"
              , "flex-wrap: wrap"
              , "justify-content: flex-end"
              ]

        , item:
            C.div /\
              case ctx.viewMode of
                Inline ->
                  [ "padding-left: 10px"
                  , "padding-right: 10px"
                  ]
                Standalone -> []

        , subRow:
            C.div /\
              [ "display: flex"
              , "align-items: center"
              , "justify-content: space-between"
              ]
        , typeName: C.div /\
            [ "font-size: 20px"
            , "grid-area: b"
            , "font-weight: bold"
            , "margin-bottom: 3px"
            ]
        , text: C.div /\
            [ "font-size: 11px"
            ]

        , header: C.div /\
            [ "margin-bottom: 20px"
            ]
        , errors: C.div /\
            [ "color: red"
            , "display: flex"
            , "flex-direction: column"
            , "gap: 3px"
            , "margin-top: 10px"
            ]
        , error: C.div /\
            [ "font-size: 11px" ]
        }

      showErrors :: Boolean
      showErrors =
        Array.length filteredErrors > 0

    in
      el.data_
        []
        [ el.header_
            [ el.item_
                [ el.subRow_
                    [ el.typeName_ [ C.text typeName ]
                    , el.actions_
                        ( map
                            (\dataAction -> UIActionButton.view { dataAction })
                            actions
                        )
                    ]
                ]
            , text # maybe C.noHtml \text' -> el.item []
                [ el.text_
                    [ C.text text' ]
                ]
            ]

        , el.item_ <<< pure $ el.content_
            [ viewContent ]

        , if showErrors then
            el.errors_
              ( filteredErrors
                  # map \error' ->
                      el.error_
                        [ C.text $ printErrorCase error' ]
              )
          else
            C.noHtml
        ]

viewInline :: forall html msg. IDHtml html => ViewDataCfg html msg -> html msg
viewInline { viewContent, typeName, text, filteredErrors } =
  withCtx \ctx ->
    let
      el = styleElems "InteractiveData.App.WrapData#viewInline"
        { typeRow:
            [ "display: flex"
            , "flex-direction: column"
            , "height: 100%"
            , "gap: 3px"
            ]
        , text:
            [ "font-size: 11px"
            ]
        , caption:
            [ "display: flex"
            , "align-items: center"
            , "justify-content: space-between"
            , "height: 100%"
            ]
        , typeName:
            [ "font-size: 12px"
            , "margin-right: 10px"
            ]
        , root:
            [ "min-width: 120px"
            , "display: grid"
            ]
        , content:
            [ ""
            ]
        , errors:
            [ "color: red"
            , "display: flex"
            , "flex-direction: column"
            , "gap: 3px"
            ]
        , error:
            [ "font-size: 11px" ]
        }

      showErrors :: Boolean
      showErrors =
        Array.length filteredErrors > 0

      typeRow :: html msg
      typeRow =
        el.typeRow_
          [ case text of
              Just text' ->
                el.text_
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
                  $ el.caption_
                      [ UIDataLabel.view
                          { dataPath: { before: [], path: ctx.path }
                          , mkTitle: UIDataLabel.mkTitleGoto
                          }
                          { onHit: Just (That $ GlobalSelectDataPath $ dataPathToStrings ctx.path)
                          , size: UIDataLabel.Large
                          , headline: true
                          }
                      , el.typeName_
                          [ C.text typeName ]
                      ]
              , viewSubCaption = Just typeRow
              , viewBody = Just $ C.div_
                  [ el.content_
                      [ viewContent ]
                  ]
              , viewFooter =
                  if showErrors then
                    Just $
                      el.errors_
                        ( filteredErrors
                            # map \error' ->
                                el.error_
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

      error = map (const unit) extractResult

      cfg :: ViewDataCfg html msg
      cfg =
        { label: label
        , typeName: cfgStatic.name
        , viewContent: viewInner childState
        , actions: cfgDynamic.actions
        , text: text
        , filteredErrors
        }

      predPath :: DataPath -> Boolean
      predPath dataPath = dataPath == []

      filteredErrors :: Array DataErrorCase
      filteredErrors =
        error
          # either NEA.toArray (const [])
          # mapMaybe
              ( \(DataError path errorCase) ->
                  if predPath path then Just errorCase
                  else Nothing
              )
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