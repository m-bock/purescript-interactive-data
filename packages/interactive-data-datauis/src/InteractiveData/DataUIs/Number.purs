module InteractiveData.DataUIs.Number
  ( NumberMsg
  , NumberState
  , CfgNumber
  , number
  , number_
  , defaultCfgNumber
  ) where

import InteractiveData.Core.Prelude

import Chameleon as VD
import InteractiveData.UI.Slider as UI.Slider

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

data NumberMsg = SetNumber Number

newtype NumberState = NumberState Number

derive newtype instance Show NumberState

-------------------------------------------------------------------------------
--- Extract
-------------------------------------------------------------------------------

extract :: NumberState -> DataResult Number
extract (NumberState s) = Right s

-------------------------------------------------------------------------------
--- Init
-------------------------------------------------------------------------------

init :: Maybe Number -> NumberState
init optStr = NumberState $ fromMaybe zero optStr

-------------------------------------------------------------------------------
--- Update
-------------------------------------------------------------------------------

update :: NumberMsg -> NumberState -> NumberState
update msg _ =
  case msg of
    SetNumber newNumber -> NumberState newNumber

-------------------------------------------------------------------------------
--- View
-------------------------------------------------------------------------------

type CfgNumberView =
  { min :: Number
  , max :: Number
  , step :: Number
  }

view :: forall html. IDHtml html => CfgNumberView -> NumberState -> html NumberMsg
view
  { min, max, step }
  (NumberState value) =
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
                , onChange: SetNumber
                }
            ]
        ]

-------------------------------------------------------------------------------
--- DataActions
-------------------------------------------------------------------------------

actions :: Array (DataAction NumberMsg)
actions = []

-------------------------------------------------------------------------------
--- DataUI
-------------------------------------------------------------------------------

type CfgNumber =
  { min :: Number
  , max :: Number
  , step :: Number
  }

defaultCfgNumber :: CfgNumber
defaultCfgNumber =
  { min: -100.0
  , max: 100.0
  , step: 1.0
  }

number
  :: forall opt html fm fs
   . OptArgs CfgNumber opt
  => IDHtml html
  => opt
  -> DataUI (IDSurface html) fm fs NumberMsg NumberState Number
number opt =
  let
    cfg :: CfgNumber
    cfg = getAllArgs defaultCfgNumber opt

  in
    DataUI \_ -> DataUiInterface
      { name: "Number"
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

number_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs NumberMsg NumberState Number
number_ = number {}