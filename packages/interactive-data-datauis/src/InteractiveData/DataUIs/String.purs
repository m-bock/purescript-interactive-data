module InteractiveData.DataUIs.String
  ( StringMsg
  , StringState
  , CfgString
  , string
  , string_
  , defaultCfgString
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Data.String as Str

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

type CfgView =
  { multiline :: Boolean
  , maxLength :: Maybe Int
  }

view :: forall html. IDHtml html => CfgView -> StringState -> html StringMsg
view
  { multiline, maxLength }
  (StringState state) =
  withCtx \ctx ->
    let
      el =
        { root: C.div
        , input: styleLeaf C.input
            [ "width: 100%"
            , "border: 1px solid #ccc"
            , "border-radius: 3px"
            ]
        , textarea: styleNode C.textarea
            [ "width: 100%"
            , "height: 100px"
            , "font-family: 'Signika Negative'"
            , "border: 1px solid #ccc"
            , "border-radius: 3px"
            ]
        , details: styleNode C.div
            [ "font-size: 10px"
            , "margin-top: 5px"
            ]
        }

      multiLineInput :: html StringMsg
      multiLineInput =
        el.textarea
          [ C.onInput SetString
          , C.value state
          , maybe C.noProp C.maxlength maxLength
          ]
          []

      singleLineInput :: html StringMsg
      singleLineInput =
        el.input
          [ C.type_ "text"
          , C.onInput SetString
          , C.value state
          , maybe C.noProp C.maxlength maxLength
          ]

      getLineInput :: Boolean -> html StringMsg
      getLineInput isMultiline =
        if isMultiline then multiLineInput
        else singleLineInput
    in
      case ctx.viewMode of
        Standalone ->
          el.root []
            [ getLineInput multiline
            , el.details []
                [ C.text ("Length: " <> show (Str.length state)) ]
            ]
        Inline ->
          el.root []
            [ singleLineInput
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
  { text :: Maybe String
  , multiline :: Boolean
  , actions :: Array (DataAction msg)
  , maxLength :: Maybe Int
  }

defaultCfgString :: CfgString StringMsg
defaultCfgString =
  { text: Nothing
  , multiline: false
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
            , text: cfg.text
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