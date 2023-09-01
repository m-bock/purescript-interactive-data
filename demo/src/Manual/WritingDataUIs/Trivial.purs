{-
# Data UIs for custom Types

<!-- START hide -->
-}
module Manual.WritingDataUIs.Trivial where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Prelude

import Chameleon (class Html)
import Chameleon as C
import Data.Maybe (Maybe(..))
import Data.These (These(..))
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->

## Define a custom type
-}

newtype Color = Color String

instance Show Color where
  show (Color s) =
    "(Color " <> show s <> ")"

{-


## Define a view
-}

type ViewColorCfg =
  ( extraConfig1 :: String
  , extraConfig2 :: Int
  )

view
  :: forall html
   . Html html
  => { | ViewColorCfg }
  -> Color
  -> html Color
view = \_ (Color colorValue) ->
  C.div_
    [ C.input
        [ C.type_ "color"
        , C.onInput Color
        , C.value colorValue
        ]
    ]

{-

## Optionally define actions
-}

actions
  :: Color
  -> Array (ID.DataAction Color)
actions _ =
  [ ID.DataAction
      { label: "Red"
      , msg: This $ Color "#ff0000"
      , description:
          "Set the color to red"
      }
  , ID.DataAction
      { label: "Green"
      , msg: This $ Color "#00ff00"
      , description:
          "Set the color to green"
      }
  , ID.DataAction
      { label: "Blue"
      , msg: This $ Color "#0000ff"
      , description:
          "Set the color to blue"
      }
  ]

{-

## Define the Data UI
-}

type ColorCfg =
  ID.TrivialCfg ViewColorCfg Color

color
  :: forall opt html
   . Html html
  => ID.OptArgs ColorCfg opt
  => opt
  -> DataUI' html Color Color Color
color =
  ID.mkTrivialDataUi
    { init: Color "#000000"
    , view
    , typeName: "Color"
    , actions
    , defaultConfig:
        { extraConfig1: "foo"
        , extraConfig2: 0
        }
    }

{-

## Use the Data UI
-}

demo
  :: forall html
   . Html html
  => DataUI' html Color Color Color
demo = color
  { text: Just "Pick a color!"
  , extraConfig1: "bar"
  , extraConfig2: 1
  }

{-

<!-- START embed trivial 300 -->
<!-- END embed -->

-}