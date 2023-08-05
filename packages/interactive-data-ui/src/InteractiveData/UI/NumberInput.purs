module InteractiveData.UI.NumberInput
  ( ViewCfg
  , class IsNumber
  , fromNumber
  , toNumber
  , view
  ) where

import Prelude

import Chameleon as C
import Chameleon.Styled (class HtmlStyled, styleLeaf, styleNode)
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
      { container: styleNode C.div
          [ "" ]
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
    valueStr = show $ toNumber value
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

instance IsNumber Int where
  fromNumber = Int.fromNumber
  toNumber = Int.toNumber

instance IsNumber Number where
  fromNumber = Just
  toNumber = identity