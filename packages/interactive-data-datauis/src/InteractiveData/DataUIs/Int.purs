module InteractiveData.DataUIs.Int
  ( IntMsg
  , IntState
  , CfgInt
  , int
  , int_
  , defaultCfgInt
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import InteractiveData.UI.NumberInput as UINumberInput
import InteractiveData.UI.Slider as UISlider

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

data IntMsg
  = SetInt Int
  | SetMin
  | SetMax
  | SetCenter

newtype IntState = IntState Int

derive newtype instance Show IntState

-------------------------------------------------------------------------------
--- Extract
-------------------------------------------------------------------------------

extract :: IntState -> DataResult Int
extract (IntState s) = Right s

-------------------------------------------------------------------------------
--- Init
-------------------------------------------------------------------------------

init :: Maybe Int -> IntState
init optStr = IntState $ fromMaybe zero optStr

-------------------------------------------------------------------------------
--- Update
-------------------------------------------------------------------------------

update
  :: { min :: Int
     , max :: Int
     }
  -> IntMsg
  -> IntState
  -> IntState
update { min, max } msg _ =
  case msg of
    SetInt newInt -> IntState newInt
    SetMin -> IntState min
    SetMax -> IntState max
    SetCenter -> IntState $ (min + max) / 2

-------------------------------------------------------------------------------
--- View
-------------------------------------------------------------------------------

type CfgView =
  { min :: Int
  , max :: Int
  , step :: Int
  }

view :: forall html. IDHtml html => CfgView -> IntState -> html IntMsg
view
  { min, max, step }
  (IntState value) =
  withCtx \_ ->
    let
      el =
        { root: styleNode C.div
            [ "display: flex"
            , "flex-direction: row"
            , "align-items: center"
            , "justify-content: space-between"
            , "gap: 10px"
            ]
        , slider: styleNode C.div
            [ "flex: 3" ]
        , input: styleNode C.div
            [ "flex: 1" ]
        }

    in
      el.root []
        [ el.slider []
            [ UISlider.view
                { min
                , max
                , step
                , value
                , onChange: SetInt
                }
            ]
        , el.input []
            [ UINumberInput.view
                { min
                , max
                , step
                , value
                , onChange: SetInt
                }
            ]
        ]

-------------------------------------------------------------------------------
--- DataActions
-------------------------------------------------------------------------------

actions :: Array (DataAction IntMsg)
actions =
  [ DataAction
      { label: "Min"
      , description: "Set to min"
      , msg: This $ SetMin
      }
  , DataAction
      { label: "Center"
      , description: "Set to center"
      , msg: This $ SetCenter
      }
  , DataAction
      { label: "Max"
      , description: "Set to max"
      , msg: This $ SetMax
      }
  ]

-------------------------------------------------------------------------------
--- DataUI
-------------------------------------------------------------------------------

type CfgInt =
  { text :: Maybe String
  , min :: Int
  , max :: Int
  , step :: Int
  }

defaultCfgInt :: CfgInt
defaultCfgInt =
  { text: Nothing
  , min: -100
  , max: 100
  , step: 1
  }

int
  :: forall opt html fm fs
   . OptArgs CfgInt opt
  => IDHtml html
  => opt
  -> DataUI (IDSurface html) fm fs IntMsg IntState Int
int opt =
  let
    cfg :: CfgInt
    cfg = getAllArgs defaultCfgInt opt

  in
    DataUI \_ -> DataUiInterface
      { name: "Int"
      , view: \state -> IDSurface \_ ->
          DataTree
            { view: view (pick cfg) state
            , actions
            , children: Fields []
            , meta: Nothing
            , text: cfg.text
            }
      , extract
      , update: update (pick cfg)
      , init
      }

int_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs IntMsg IntState Int
int_ = int {}