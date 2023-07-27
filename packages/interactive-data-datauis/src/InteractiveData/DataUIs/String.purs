module InteractiveData.DataUIs.String where

import InteractiveData.Prelude.UI

import Data.String as Str
import InteractiveData.Core.Types (DataUI(..), DataUiItf(..), Opt)
import InteractiveData.Core.Types as Core
import InteractiveData.Defaults (class Cfg, getAll)
import InteractiveData.Types (class IDHtml, DataTree(..), DataTreeChildren(..), IDDataUI, IDSurface(..), ViewMode(..))
import InteractiveData.Types.DataTree (DataAction(..), Icon(..))
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

stringExtract :: StringState -> Opt String
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

stringView :: forall html. IDHtml html => CfgView -> StringState -> html StringMsg
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
      Standalone ->
        el.root []
          [ getLineInput multiline.standalone
          , el.details []
              [ VD.text ("Length: " <> show (Str.length state)) ]
          ]
      Inline ->
        el.root []
          [ getLineInput multiline.inline
          ]

-------------------------------------------------------------------------------
--- DataActions
-------------------------------------------------------------------------------

stringActions :: Array (DataAction StringMsg)
stringActions =
  [ DataAction
      { icon: IconUnicode 'x'
      , label: "Clear"
      , msg: This $ SetString ""
      , description: "Clear the string"
      }
  , DataAction
      { icon: IconUnicode 'x'
      , label: "Trim"
      , msg: This $ TrimString
      , description: "Trim whitespace from string"
      }
  ]

-------------------------------------------------------------------------------
--- DataUI
-------------------------------------------------------------------------------

type DataUIString html fm fs = Core.DataUI
  (IDSurface html)
  fm
  fs
  StringMsg
  StringState
  String

type CfgString msg =
  { multiline ::
      { inline :: Boolean
      , standalone :: Boolean
      }
  , actions :: Array (DataAction msg)
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
   . Cfg (CfgString StringMsg) opt
  => IDHtml html
  => opt
  -> DataUIString html fm fs
string opt =
  let
    cfg :: CfgString StringMsg
    cfg = getAll defaults opt

    { multiline, actions, maxLength } = cfg
  in
    DataUI \_ -> DataUiItf
      { name: "String"
      , view: \state -> IDSurface \_ ->
          DataTree
            { view: stringView { multiline, maxLength } state
            , actions
            , children: Fields []
            , meta: Nothing
            }
      , extract: stringExtract
      , update: stringUpdate
      , init: stringInit
      }

string_ :: forall html fm fs. IDHtml html => DataUIString html fm fs
string_ = string {}