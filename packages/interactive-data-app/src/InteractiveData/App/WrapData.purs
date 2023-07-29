module InteractiveData.App.WrapData where

import InteractiveData.Core.Prelude

import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Tuple (fst)
import DataMVC.Types.DataError (DataError(..))
import InteractiveData.App.UI.Card as UI.Card
import InteractiveData.App.UI.DataLabel as UI.DataLabel
import InteractiveData.Core (class IDHtml, DataAction, DataError, DataErrorCase(..), DataResult, DataTree(..), DataUICtx(..), DataUiItf(..), IDDataUICtx, IDOutMsg(..), IDSurface(..), IDViewCtx, TreeMeta, ViewMode(..), WrapMsg(..), WrapState(..))
import InteractiveData.Core.Types.DataPathExtra (dataPathToStrings, segmentToString)
import InteractiveData.Core.Types.IDDataUI (runIdSurface)
import InteractiveData.UI.ActionButton (viewActionButton)
import VirtualDOM as VD
import VirtualDOM.Transformers.Ctx.Class (withCtx)
import VirtualDOM.Transformers.OutMsg.Class (fromOutHtml)
import VirtualDOM.Types (ElemNode)

type ViewDataCfg (html :: Type -> Type) msg =
  { label :: String
  , typeName :: String
  , viewContent :: html msg
  , actions :: Array (DataAction msg)
  , error :: Either (NonEmptyArray DataError) Unit
  }

viewData :: forall html msg. IDHtml html => ViewDataCfg html msg -> html msg
viewData cfg =
  withCtx \ctx ->
    case ctx.viewMode of
      Inline ->
        viewInline cfg
      Standalone ->
        viewStandalone cfg

viewStandalone :: forall html msg. IDHtml html => ViewDataCfg html msg -> html msg
viewStandalone { viewContent, actions } =
  withCtx \ctx ->
    let

      el =

        { data_: styleNode VD.div
            [ case ctx.viewMode of
                Inline -> "background-color: #f8f8f8"
                Standalone -> "background-color: white"
            , "margin-bottom: 20px"
            , "position: relative"
            , "border-radius: 5px"
            , "padding-bottom: 5px"
            , "padding-top: 10px"
            , case ctx.viewMode of
                Inline -> "border: 1px solid #ddd"
                Standalone -> ""
            ]
        , content: VD.div
        , actions:
            styleNode VD.div
              [ "display: flex"
              ]
        , item:
            styleNode VD.div
              case ctx.viewMode of
                Inline ->
                  [ "padding-left: 10px"
                  , "padding-right: 10px"
                  ]
                Standalone -> []

        , subRow:
            styleNode VD.div
              [ "display: flex"
              , "margin-bottom: 10px"
              , "align-items: center"
              , "justify-content: right"
              ] :: ElemNode html msg

        }

    in
      el.data_
        []
        [ el.item []
            [ el.subRow []
                [ el.actions []
                    ( map
                        (\dataAction -> viewActionButton { dataAction })
                        actions
                    )
                ]
            ]

        , el.item [] <<< pure $ el.content []
            [ viewContent ]
        ]

viewInline :: forall html msg. IDHtml html => ViewDataCfg html msg -> html msg
viewInline { viewContent, typeName, actions } =
  withCtx \ctx ->
    let
      el =
        { typeRow: styleNode VD.div
            [ "display: flex"
            , "margin-bottom: 10px"
            , "align-items: center"
            , "justify-content: space-between"
            ]
        , typeName: styleNode VD.div
            [ "font-size: 13px"
            , "margin-right: 10px"
            , "font-weight: bold"
            ]
        , actions: styleNode VD.div
            [ "display: flex"
            ]
        }

      typeRow :: html msg
      typeRow =
        el.typeRow []
          [ el.typeName []
              [ VD.text typeName ]
          , el.actions []
              ( map
                  (\dataAction -> viewActionButton { dataAction })
                  actions
              )
          ]

    in
      UI.Card.viewCard
        { viewBody: VD.div []
            [ typeRow
            , viewContent
            ]
        }
        UI.Card.defaultViewCardOpt
          { viewCaption = Just
              $ fromOutHtml
              $ UI.DataLabel.viewDataLabel
                  { dataPath: { before: [], path: ctx.path }
                  , mkTitle: UI.DataLabel.mkTitleGoto
                  }
                  { onHit: Just (That $ GlobalSelectDataPath $ dataPathToStrings ctx.path)
                  , size: UI.DataLabel.Large
                  }
          }

printError :: DataError -> String
printError (DataError _ case_) = case case_ of
  DataErrNotYetDefined -> "Not yet defined"
  DataErrMsg msg -> msg

--------------------------------------------------------------------------------
--- View
--------------------------------------------------------------------------------

type ViewCfgStatic sta a =
  { name :: String
  , extract :: sta -> DataResult a
  }

type ViewCfgDynamic html msg sta =
  { actions :: Array (DataAction msg)
  , viewInner :: sta -> html msg
  }

dataWrapperView
  :: forall html msg sta a
   . IDHtml html
  => ViewCfgStatic sta a
  -> ViewCfgDynamic html msg sta
  -> WrapState sta
  -> html (WrapMsg msg)
dataWrapperView cfgStatic cfgDynamic@{ viewInner } (WrapState { childState }) =
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

dataWrapperUpdate :: forall msg sta. (msg -> sta -> sta) -> WrapMsg msg -> WrapState sta -> WrapState sta
dataWrapperUpdate update' msg (WrapState sta) = WrapState case msg of
  ChildMsg childMsg -> sta
    { childState = update' childMsg sta.childState
    }

--------------------------------------------------------------------------------
--- Extract
--------------------------------------------------------------------------------

dataWrapperExtract :: forall sta a. (sta -> DataResult a) -> WrapState sta -> DataResult a
dataWrapperExtract ext (WrapState state) = ext state.childState

--------------------------------------------------------------------------------
--- Init
--------------------------------------------------------------------------------

dataWrapperInit :: forall sta a. (Maybe a -> sta) -> Maybe a -> (WrapState sta)
dataWrapperInit ini opta = WrapState
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
  }

viewDataTree
  :: forall sta html msg a
   . IDHtml html
  => ViewDataTreeCfg html msg sta a
  -> WrapState sta
  -> DataTree html (WrapMsg msg)
viewDataTree { viewInner, viewHtml, extract, typeName } state@(WrapState { childState }) =
  let
    (DataTree { actions, children }) = viewInner childState

    extractResult :: DataResult a
    extractResult = extract childState

    meta :: TreeMeta
    meta =
      { errored: map (const unit) extractResult
      , typeName
      }
  in
    DataTree
      { view:
          viewHtml
            { actions
            , viewInner: viewInner >>> un DataTree >>> _.view
            }
            state
      , children: map ChildMsg $ children
      , actions: map ChildMsg <$> actions
      , meta: Just meta
      }

dataUiItf
  :: forall html msg sta a
   . IDHtml html
  => DataUiItf (IDSurface html) msg sta a
  -> DataUiItf (IDSurface html) (WrapMsg msg) (WrapState sta) a
dataUiItf (DataUiItf { name, extract, init, update, view }) = DataUiItf
  { name
  , view: \state -> IDSurface \ctx ->
      viewDataTree
        { viewHtml: dataWrapperView { name, extract }
        , viewInner: view >>> runIdSurface ctx
        , extract
        , typeName: name
        }
        state
  , extract: dataWrapperExtract extract
  , update: dataWrapperUpdate update
  , init: dataWrapperInit init
  }

---

dataUiCtx :: forall html. IDHtml html => IDDataUICtx html
dataUiCtx = DataUICtx { wrap: \s -> dataUiItf s }