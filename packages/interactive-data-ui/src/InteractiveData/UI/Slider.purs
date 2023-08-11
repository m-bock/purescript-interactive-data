module InteractiveData.UI.Slider
  ( ViewCfg
  , class IsNumber
  , fromNumber
  , toNumber
  , view
  ) where

import Prelude

import Chameleon as C
import Chameleon.Styled (class HtmlStyled, declWith, mergeDecl, styleLeaf)
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.Number as Num
import Data.Tuple.Nested ((/\))

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
    thumbCommon =
      [ "width: 20px"
      , "height: 20px"
      , "border: 1px solid #ccc"
      , "border-radius: 50%"
      , "background: #caf1ff"
      , "cursor: pointer"
      ]

    el =
      { container: C.div
      , input:
          styleLeaf C.input $
            [ "width: 100%"
            , "-webkit-appearance: none"
            , "height: 10px"
            , "border-radius: 5px"
            , "background: #efefef"
            , "border: 1px solid #d5d5d5"
            , "outline: none"
            , "opacity: 0.7"
            ]
              /\ declWith "::-webkit-slider-thumb"
                [ "webkit-appearance: none"
                , "appearance: none"
                , mergeDecl thumbCommon
                ]
              /\ declWith "::-moz-range-thumb"
                thumbCommon
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
            [ C.type_ "range"
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