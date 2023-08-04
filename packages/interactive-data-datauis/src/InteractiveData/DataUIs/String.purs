module InteractiveData.DataUIs.String
  ( StringMsg
  , StringState
  , CfgString
  , string
  , string_
  , defaultCfgString
  ) where

import InteractiveData.Core.Prelude

import Chameleon as VD
import Data.String as Str
import InteractiveData.Core.Util.RecordProjection (pick)

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

data StringMsg
  = SetString String
  | Clear
  | TrimString

newtype StringState = StringState String

derive newtype instance Show StringState

-------------------------------------------------------------------------------
--- Extract
-------------------------------------------------------------------------------

extract :: StringState -> DataResult String
extract (StringState s) = Right s

-------------------------------------------------------------------------------
--- Init
-------------------------------------------------------------------------------

init :: Maybe String -> StringState
init optStr = StringState $ fromMaybe "" optStr

-------------------------------------------------------------------------------
--- Update
-------------------------------------------------------------------------------

update :: StringMsg -> StringState -> StringState
update msg (StringState state) =
  case msg of
    SetString newString -> StringState newString
    Clear -> StringState ""
    TrimString -> StringState $ Str.trim state

-------------------------------------------------------------------------------
--- View
-------------------------------------------------------------------------------

type CfgStringView =
  { multilineInline :: Boolean
  , multilineStandalone :: Boolean
  , maxLength :: Maybe Int
  }

view :: forall html. IDHtml html => CfgStringView -> StringState -> html StringMsg
view
  { multilineInline, multilineStandalone, maxLength }
  (StringState state) =
  withCtx \ctx ->
    let
      el =
        { root: VD.div
        , input: styleLeaf VD.input
            [ "width: 100%" ]
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

      multiLineInput :: html StringMsg
      multiLineInput =
        el.textarea
          [ VD.onInput SetString
          , VD.value state
          , maybe VD.noProp VD.maxlength maxLength
          ]
          []

      singleLineInput :: html StringMsg
      singleLineInput =
        el.input
          [ VD.type_ "text"
          , VD.onInput SetString
          , VD.value state
          , maybe VD.noProp VD.maxlength maxLength
          ]

      getLineInput :: Boolean -> html StringMsg
      getLineInput isMultiline =
        if isMultiline then multiLineInput
        else singleLineInput
    in
      case ctx.viewMode of
        Standalone ->
          el.root []
            [ getLineInput multilineStandalone
            , el.details []
                [ VD.text ("Length: " <> show (Str.length state)) ]
            ]
        Inline ->
          el.root []
            [ getLineInput multilineInline
            ]

-------------------------------------------------------------------------------
--- DataActions
-------------------------------------------------------------------------------

actions :: Array (DataAction StringMsg)
actions =
  [ DataAction
      { label: "Clear"
      , msg: This $ Clear
      , description: "Clear the string"
      }
  , DataAction
      { label: "Trim"
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
  , actions :: Array (DataAction msg)
  , maxLength :: Maybe Int
  }

defaultCfgString :: CfgString StringMsg
defaultCfgString =
  { multilineInline: false
  , multilineStandalone: true
  , actions
  , maxLength: Nothing
  }

string
  :: forall opt html fm fs
   . OptArgs (CfgString StringMsg) opt
  => IDHtml html
  => opt
  -> DataUI (IDSurface html) fm fs StringMsg StringState String
string opt =
  let
    cfg :: CfgString StringMsg
    cfg = getAllArgs defaultCfgString opt

  in
    DataUI \_ -> DataUiInterface
      { name: "String"
      , view: \state -> IDSurface \_ ->
          DataTree
            { view: view (pick cfg) state
            , actions
            , children: Fields []
            , meta: Nothing
            }
      , extract
      , update
      , init
      }

string_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs StringMsg StringState String
string_ = string {}