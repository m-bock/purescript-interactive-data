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
  { minVal :: Maybe Number
  , maxVal :: Maybe Number
  }

view :: forall html. IDHtml html => CfgNumberView -> NumberState -> html NumberMsg
view
  _
  (NumberState val) =
  withCtx \ctx ->
    let
      el =
        { root: VD.div
        }

    in
      case ctx.viewMode of
        Standalone ->
          el.root []
            [ VD.text (show val)
            , UI.Slider.view
                { min: 0.0
                , max: 100.0
                , step: 1.0
                , value: val
                , onChange: SetNumber
                }
            ]
        Inline ->
          el.root []
            [ VD.text (show val)
            , UI.Slider.view
                { min: 0.0
                , max: 100.0
                , step: 1.0
                , value: val
                , onChange: SetNumber
                }
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
  { minVal :: Maybe Number
  , maxVal :: Maybe Number
  }

defaultCfgNumber :: CfgNumber
defaultCfgNumber =
  { minVal: Nothing
  , maxVal: Nothing
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