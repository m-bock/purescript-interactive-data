module InteractiveData.DataUIs.String
  ( StringMsg
  , StringState
  , CfgString
  , string
  , string_
  , defaultCfgString
  ) where

import InteractiveData.Core.Prelude

import Data.String as Str
import DataMVC.Types (DataResult, DataUI(..), DataUiInterface(..))

import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.Core as Core
import InteractiveData.Core.Classes.OptArgs (class OptArgs, getAllArgs)

import Chameleon as VD

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

data StringMsg
  = SetString String
  | TrimString

newtype StringState = StringState String

derive newtype instance Show StringState

-------------------------------------------------------------------------------
--- Extract
-------------------------------------------------------------------------------

stringExtract :: StringState -> DataResult String
stringExtract (StringState s) = Right s

-------------------------------------------------------------------------------
--- Init
-------------------------------------------------------------------------------

stringInit :: Maybe String -> StringState
stringInit optStr = StringState $ fromMaybe "" optStr

-------------------------------------------------------------------------------
--- Update
-------------------------------------------------------------------------------

stringUpdate :: StringMsg -> StringState -> StringState
stringUpdate msg (StringState state) =
  case msg of
    SetString newString -> StringState newString
    TrimString -> StringState $ Str.trim state

-------------------------------------------------------------------------------
--- View
-------------------------------------------------------------------------------

type CfgView =
  { multilineInline :: Boolean
  , multilineStandalone :: Boolean
  , maxLength :: Maybe Int
  }

stringView :: forall html. Core.IDHtml html => CfgView -> StringState -> html StringMsg
stringView { multilineInline, multilineStandalone, maxLength } (StringState state) = withCtx \ctx ->
  let
    el =
      { root: VD.div
      , input: styleLeaf VD.input
          "width: 100%"
      , textarea: styleNode VD.textarea
          [ "width: 100%"
          , "height: 200px"
          , "font-family: 'Signika Negative'"
          ]
      , details: styleNode VD.div
          [ "font-size: 10px"
          , "margin-top: 5px"
          ]
      }

    multilineInput :: html StringMsg
    multilineInput =
      el.textarea
        [ VD.onInput SetString
        , VD.value state
        , maybe VD.noProp VD.maxlength maxLength
        ]
        []

    lineInput :: html StringMsg
    lineInput =
      el.input
        [ VD.type_ "text"
        , VD.onInput SetString
        , VD.value state
        , maybe VD.noProp VD.maxlength maxLength
        ]

    getLineInput :: Boolean -> html StringMsg
    getLineInput isMultiline =
      if isMultiline then multilineInput
      else lineInput
  in
    case ctx.viewMode of
      Core.Standalone ->
        el.root []
          [ getLineInput multilineStandalone
          , el.details []
              [ VD.text ("Length: " <> show (Str.length state)) ]
          ]
      Core.Inline ->
        el.root []
          [ getLineInput multilineInline
          ]

-------------------------------------------------------------------------------
--- DataActions
-------------------------------------------------------------------------------

stringActions :: Array (Core.DataAction StringMsg)
stringActions =
  [ Core.DataAction
      { icon: Core.IconUnicode 'x'
      , label: "Clear"
      , msg: This $ SetString ""
      , description: "Clear the string"
      }
  , Core.DataAction
      { icon: Core.IconUnicode 'x'
      , label: "Trim"
      , msg: This $ TrimString
      , description: "Trim whitespace from string"
      }
  ]

-------------------------------------------------------------------------------
--- DataUI
-------------------------------------------------------------------------------

type CfgString msg =
  { multilineInline :: Boolean
  , multilineStandalone :: Boolean
  , actions :: Array (Core.DataAction msg)
  , maxLength :: Maybe Int
  }

defaultCfgString :: CfgString StringMsg
defaultCfgString =
  { multilineInline: false
  , multilineStandalone: true
  , actions: stringActions
  , maxLength: Nothing
  }

string
  :: forall opt html fm fs
   . OptArgs (CfgString StringMsg) opt
  => Core.IDHtml html
  => opt
  -> DataUI (IDSurface html) fm fs StringMsg StringState String
string opt =
  let
    cfg :: CfgString StringMsg
    cfg = getAllArgs defaultCfgString opt

    { multilineInline, multilineStandalone, actions, maxLength } = cfg
  in
    DataUI \_ -> DataUiInterface
      { name: "String"
      , view: \state -> Core.IDSurface \_ ->
          Core.DataTree
            { view: stringView { multilineInline, multilineStandalone, maxLength } state
            , actions
            , children: Core.Fields []
            , meta: Nothing
            }
      , extract: stringExtract
      , update: stringUpdate
      , init: stringInit
      }

string_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs StringMsg StringState String
string_ = string {}