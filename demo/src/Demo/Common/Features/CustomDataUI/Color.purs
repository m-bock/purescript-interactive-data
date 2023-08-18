module Demo.Common.Features.CustomDataUI.Color
  ( CfgColor
  , Color
  , ColorMsg(..)
  , ColorState(..)
  , color
  , color_
  , defaultCfgColor
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Data.Argonaut (class DecodeJson, class EncodeJson)
import Data.Int as Int
import Data.String as Str

-------------------------------------------------------------------------------
--- Data Type
-------------------------------------------------------------------------------

newtype Color = Color
  { red :: Int
  , green :: Int
  , blue :: Int
  }

derive newtype instance EncodeJson Color
derive newtype instance DecodeJson Color
derive newtype instance Show Color

black :: Color
black = Color { red: 0, green: 0, blue: 0 }

lighten :: Int -> Color -> Color
lighten step (Color { red, green, blue }) = Color
  { red:
      min 255 (red + step)
  , green:
      min 255 (green + step)
  , blue:
      min 255 (blue + step)
  }

darken :: Int -> Color -> Color
darken step (Color { red, green, blue }) = Color
  { red:
      max 0 (red - step)
  , green:
      max 0 (green - step)
  , blue:
      max 0 (blue - step)
  }

-------------------------------------------------------------------------------
--- Data UI Types
-------------------------------------------------------------------------------

data ColorMsg
  = SetColor Color
  | Lighten
  | Darken

newtype ColorState = ColorState Color

derive newtype instance Show ColorState

-------------------------------------------------------------------------------
--- Extract
-------------------------------------------------------------------------------

extract :: ColorState -> DataResult Color
extract (ColorState s) = Right s

-------------------------------------------------------------------------------
--- Init
-------------------------------------------------------------------------------

init :: Maybe Color -> ColorState
init optStr = ColorState $ fromMaybe black optStr

-------------------------------------------------------------------------------
--- Update
-------------------------------------------------------------------------------

update :: CfgColor -> ColorMsg -> ColorState -> ColorState
update { lightenStep, darkenStep } msg (ColorState oldColor) =
  case msg of
    SetColor newColor ->
      ColorState newColor

    Lighten ->
      ColorState $ lighten lightenStep oldColor

    Darken ->
      ColorState $ darken darkenStep oldColor

-------------------------------------------------------------------------------
--- View
-------------------------------------------------------------------------------

view :: forall html. IDHtml html => ColorState -> html ColorMsg
view (ColorState selectedColor) =
  withCtx \_ ->
    let
      handleColorChange :: String -> ColorMsg
      handleColorChange hexStr =
        let
          result :: Maybe Color
          result = hexStrToColor hexStr

          color' :: Color
          color' = fromMaybe black result
        in
          SetColor color'

      colorValue :: String
      colorValue = colorToHexStr selectedColor
    in
      C.div_
        [ C.input
            [ C.type_ "color"
            , C.onChange handleColorChange
            , C.value colorValue
            ]
        , C.text " Example of a custom Data UI, pick a color!"
        ]

-------------------------------------------------------------------------------
--- DataActions
-------------------------------------------------------------------------------

actions :: Array (DataAction ColorMsg)
actions =
  [ DataAction
      { label: "Lighten"
      , msg: This $ Lighten
      , description: "Lighten the color"
      }
  , DataAction
      { label: "Darken"
      , msg: This $ Darken
      , description: "Darken the color"
      }
  ]

-------------------------------------------------------------------------------
--- DataUI
-------------------------------------------------------------------------------

type CfgColor =
  { text :: Maybe String
  , lightenStep :: Int
  , darkenStep :: Int
  }

defaultCfgColor :: CfgColor
defaultCfgColor =
  { text: Nothing
  , lightenStep: 10
  , darkenStep: 10
  }

color
  :: forall opt html fm fs
   . OptArgs CfgColor opt
  => IDHtml html
  => opt
  -> DataUI (IDSurface html) fm fs ColorMsg ColorState Color
color opt =
  let
    cfg :: CfgColor
    cfg = getAllArgs defaultCfgColor opt

  in
    DataUI \_ -> DataUiInterface
      { name: "Color"
      , view: \state -> IDSurface \_ ->
          DataTree
            { view: view state
            , actions
            , children: Fields []
            , meta: Nothing
            , text: cfg.text
            }
      , extract
      , update: update cfg
      , init
      }

color_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs ColorMsg ColorState Color
color_ = color {}

-------------------------------------------------------------------------------
--- Utils
-------------------------------------------------------------------------------

hexStrToColor :: String -> Maybe Color
hexStrToColor str = do
  hexStrings :: String <- Str.stripPrefix (Str.Pattern "#") str

  let r_str = hexStrings # Str.drop 0 # Str.take 2
  let g_str = hexStrings # Str.drop 2 # Str.take 2
  let b_str = hexStrings # Str.drop 4 # Str.take 2

  r :: Int <- Int.fromStringAs Int.hexadecimal r_str
  g :: Int <- Int.fromStringAs Int.hexadecimal g_str
  b :: Int <- Int.fromStringAs Int.hexadecimal b_str

  pure $ Color { red: r, green: g, blue: b }

colorToHexStr :: Color -> String
colorToHexStr (Color { red, green, blue }) =
  "#"
    <> intToHexStr red
    <> intToHexStr green
    <> intToHexStr blue

intToHexStr :: Int -> String
intToHexStr n =
  let
    result :: String
    result = Int.toStringAs Int.hexadecimal n
  in
    if Str.length result == 1 then
      "0" <> result
    else
      result