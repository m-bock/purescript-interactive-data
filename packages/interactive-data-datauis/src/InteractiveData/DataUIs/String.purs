module InteractiveData.DataUIs.String
  ( StringMsg(..)
  , StringState(..)
  , string
  , string_
  ) where

import InteractiveData.Core.Prelude

import Data.String as Str
import InteractiveData.Core (IDSurface(..))
import InteractiveData.Core as Core
import InteractiveData.Core.Classes.OptArgs (class OptArgs, getAllArgs)
import VirtualDOM as VD

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

data StringMsg
  = SetString String
  | TrimString

newtype StringState = StringState String

-------------------------------------------------------------------------------
--- Extract
-------------------------------------------------------------------------------

stringExtract :: StringState -> Core.DataResult String
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
  { multiline :: { inline :: Boolean, standalone :: Boolean }
  , maxLength :: Maybe Int
  }

stringView :: forall html. Core.IDHtml html => CfgView -> StringState -> html StringMsg
stringView { multiline, maxLength } (StringState state) = withCtx \ctx ->
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
          [ getLineInput multiline.standalone
          , el.details []
              [ VD.text ("Length: " <> show (Str.length state)) ]
          ]
      Core.Inline ->
        el.root []
          [ getLineInput multiline.inline
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
  { multiline ::
      { inline :: Boolean
      , standalone :: Boolean
      }
  , actions :: Array (Core.DataAction msg)
  , maxLength :: Maybe Int
  }

defaults :: CfgString StringMsg
defaults =
  { multiline:
      { inline: false
      , standalone: true
      }
  , actions: stringActions
  , maxLength: Nothing
  }

string
  :: forall opt html fm fs
   . OptArgs (CfgString StringMsg) opt
  => Core.IDHtml html
  => opt
  -> Core.DataUI (IDSurface html) fm fs StringMsg StringState String
string opt =
  let
    cfg :: CfgString StringMsg
    cfg = getAllArgs defaults opt

    { multiline, actions, maxLength } = cfg
  in
    Core.DataUI \_ -> Core.DataUiItf
      { name: "String"
      , view: \state -> Core.IDSurface \_ ->
          Core.DataTree
            { view: stringView { multiline, maxLength } state
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
   . Core.IDHtml html
  => Core.DataUI (IDSurface html) fm fs StringMsg StringState String
string_ = string {}