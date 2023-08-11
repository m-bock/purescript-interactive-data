module InteractiveData.UI.NumberInput
  ( ViewCfg
  , class IsNumber
  , fromNumber
  , toNumber
  , toString
  , view
  ) where

import Prelude

import Chameleon as C
import Chameleon.Styled (class HtmlStyled, styleLeaf)
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.Number as Num

type ViewCfg num msg =
  { min :: num
  , max :: num
  , step :: num
  , value :: num
  , onChange :: num -> msg
  }

view :: forall html num msg. HtmlStyled html => IsNumber num => ViewCfg num msg -> html msg
view { onChange, value, min, max, step } =
  let
    el =
      { container: C.div
      , input: styleLeaf C.input
          [ "width: 100%"
          , "border-radius: 3px"
          , "background: white"
          , "border: 1px solid #d5d5d5"
          ]
      }

    handleInput :: String -> Maybe msg
    handleInput val = do
      number :: Number <- Num.fromString val
      num :: num <- fromNumber number

      pure $ onChange num

    valueStr :: String
    valueStr = toString value
  in
    el.container []
      [ C.mapMaybe identity $
          el.input
            [ C.type_ "number"
            , C.min $ toNumber $ min
            , C.max $ toNumber max
            , C.value valueStr
            , C.step $ toNumber step
            , C.onInput handleInput
            ]
      ]

--------------------------------------------------------------------------------
--- IsNumber
--------------------------------------------------------------------------------

class IsNumber a where
  fromNumber :: Number -> Maybe a
  toNumber :: a -> Number
  toString :: a -> String

instance IsNumber Int where
  fromNumber :: Number -> Maybe Int
  fromNumber = Int.fromNumber

  toNumber :: Int -> Number
  toNumber = Int.toNumber

  toString :: Int -> String
  toString = show

instance IsNumber Number where
  fromNumber :: Number -> Maybe Number
  fromNumber = Just

  toNumber :: Number -> Number
  toNumber = identity

  toString :: Number -> String
  toString = show