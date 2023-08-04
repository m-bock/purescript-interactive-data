module InteractiveData.DataUIs.Int
  ( IntMsg
  , IntState
  , CfgInt
  , int
  , int_
  , defaultCfgInt
  ) where

import InteractiveData.Core.Prelude

import Chameleon as VD
import InteractiveData.UI.Slider as UI.Slider

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

data IntMsg = SetInt Int

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

update :: IntMsg -> IntState -> IntState
update msg _ =
  case msg of
    SetInt newInt -> IntState newInt

-------------------------------------------------------------------------------
--- View
-------------------------------------------------------------------------------

type CfgIntView =
  { min :: Int
  , max :: Int
  , step :: Int
  }

view :: forall html. IDHtml html => CfgIntView -> IntState -> html IntMsg
view
  { min, max, step }
  (IntState value) =
  withCtx \_ ->
    let
      el =
        { root: VD.div
        , slider: styleNode VD.div
            [ "margin-top: 10px"
            , "margin-bottom: 5px"
            ]
        }

    in
      el.root []
        [ VD.text (show value)
        , el.slider []
            [ UI.Slider.view
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
actions = []

-------------------------------------------------------------------------------
--- DataUI
-------------------------------------------------------------------------------

type CfgInt =
  { min :: Int
  , max :: Int
  , step :: Int
  }

defaultCfgInt :: CfgInt
defaultCfgInt =
  { min: -100
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
            }
      , extract
      , update
      , init
      }

int_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs IntMsg IntState Int
int_ = int {}