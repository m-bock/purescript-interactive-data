module InteractiveData.DataUIs.Number
  ( NumberMsg
  , NumberState
  , CfgNumber
  , number
  , number_
  , defaultCfgNumber
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import InteractiveData.UI.NumberInput as UI.NumberInput
import InteractiveData.UI.Slider as UI.Slider

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

data NumberMsg
  = SetNumber Number
  | SetMin
  | SetMax
  | SetCenter

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

update
  :: { min :: Number
     , max :: Number
     }
  -> NumberMsg
  -> NumberState
  -> NumberState
update { min, max } msg _ =
  case msg of
    SetNumber newNumber -> NumberState newNumber
    SetMin -> NumberState min
    SetMax -> NumberState max
    SetCenter -> NumberState $ (min + max) / 2.0

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
        { root: styleNode C.div
            [ "margin-top: 10px"
            , "margin-bottom: 5px"
            , "display: flex"
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
            [ UI.Slider.view
                { min
                , max
                , step
                , value
                , onChange: SetNumber
                }
            ]
        , el.input []
            [ UI.NumberInput.view
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
      , update: update (pick cfg)
      , init
      }

number_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs NumberMsg NumberState Number
number_ = number {}