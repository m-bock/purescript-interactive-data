module InteractiveData.DataUIs.Json
  ( JsonMsg
  , JsonState
  , JsonCfg
  , JsonMandatory
  , JsonOptional
  , json
  , defaultCfgJson
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Data.Argonaut (class DecodeJson, class EncodeJson, Json, JsonDecodeError, decodeJson, encodeJson)
import Data.Argonaut as Json
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Bifunctor (lmap)
import Data.Int as Int

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

data JsonMsg
  = SetJson String
  | FormatJson

newtype JsonState = JsonState String

derive newtype instance Show JsonState

-------------------------------------------------------------------------------
--- Extract
-------------------------------------------------------------------------------

extract :: forall a. DecodeJson a => JsonState -> DataResult a
extract (JsonState str) =
  lmap mapError do
    json' :: Json <- Json.parseJson str
    decodeJson json'

  where
  mapError :: JsonDecodeError -> NonEmptyArray DataError
  mapError jsonErr = pure $
    DataError [] (DataErrMsg $ Json.printJsonDecodeError jsonErr)

-------------------------------------------------------------------------------
--- Init
-------------------------------------------------------------------------------

init :: forall a. EncodeJson a => { init :: a } -> Maybe a -> JsonState
init { init: init' } optStr = JsonState
  $ Json.stringifyWithIndent 2
  $ encodeJson
  $ fromMaybe init' optStr

-------------------------------------------------------------------------------
--- Update
-------------------------------------------------------------------------------

update
  :: JsonMsg
  -> JsonState
  -> JsonState
update msg state@(JsonState val) =
  case msg of
    SetJson newJson -> JsonState newJson
    FormatJson ->
      fromRight state do
        json' :: Json <- Json.parseJson val
        pure $ JsonState (Json.stringifyWithIndent 2 json')

-------------------------------------------------------------------------------
--- View
-------------------------------------------------------------------------------

view :: forall html. IDHtml html => { rows :: Int } -> JsonState -> html JsonMsg
view { rows } (JsonState value) =
  let
    el = styleElems "InteractiveData.DataUIs.Json#view"
      { textarea: C.textarea /\
          [ "width: 100%"
          , "font-family: monospace"
          , "border: 1px solid #ccc"
          , "border-radius: 3px"
          ]
      }
  in
    el.textarea
      [ C.onInput SetJson
      , C.value value
      , C.rows $ Int.toNumber rows
      ]
      []

-------------------------------------------------------------------------------
--- DataActions
-------------------------------------------------------------------------------

actions :: Array (DataAction JsonMsg)
actions =
  [ DataAction
      { label: "Format JSON"
      , description: "Format JSON with indentation"
      , msg: This $ FormatJson
      }
  ]

-------------------------------------------------------------------------------
--- DataUI
-------------------------------------------------------------------------------

type JsonCfg a = Record (JsonMandatory a (JsonOptional ()))

type JsonMandatory a r =
  ( init :: a
  , typeName :: String
  | r
  )

type JsonOptional r =
  ( text :: Maybe String
  , rows :: Int
  | r
  )

defaultCfgJson :: Record (JsonOptional ())
defaultCfgJson =
  { text: Nothing
  , rows: 15
  }

json
  :: forall given html fm fs a
   . OptArgsMixed
       (JsonCfg a)
       (JsonOptional ())
       given
  => DecodeJson a
  => EncodeJson a
  => IDHtml html
  => given
  -> DataUI (IDSurface html) fm fs JsonMsg JsonState a
json opt =
  let
    cfg :: JsonCfg a
    cfg = getAllArgsMixed defaultCfgJson opt

  in
    DataUI \_ -> DataUiInterface
      { name: cfg.typeName
      , view: \state -> IDSurface \_ ->
          DataTree
            { view: view (pick cfg) state
            , actions
            , children: Fields []
            , meta: Nothing
            , text: cfg.text
            }
      , extract
      , update: update
      , init: init { init: cfg.init }
      }

