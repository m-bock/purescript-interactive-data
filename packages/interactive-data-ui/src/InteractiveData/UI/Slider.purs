module InteractiveData.UI.Slider where

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
view { onChange, value } =
  let

    el =
      { container: styleNode C.div
          [ "" ]
      , input: styleLeaf C.input
          [ "" ]
      }

    handleInput :: String -> Maybe msg
    handleInput val = do
      number :: Number <- Num.fromString val
      num :: num <- parse number

      pure $ onChange num

    valueStr :: String
    valueStr = show $ print value
  in
    el.container []
      [ C.mapMaybe identity $
          el.input
            [ C.type_ "range"
            , C.min 1.0
            , C.max 100.0
            , C.value valueStr
            , C.step 1.0
            , C.onInput handleInput
            ]
      ]

--------------------------------------------------------------------------------
--- IsNumber
--------------------------------------------------------------------------------

class IsNumber a where
  parse :: Number -> Maybe a
  print :: a -> Number

instance IsNumber Int where
  parse = Int.fromNumber
  print = Int.toNumber

instance IsNumber Number where
  parse = Just
  print = identity