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

init :: { initCfg :: Maybe Number } -> Maybe Number -> NumberState
init { initCfg } initGlobal = case initCfg, initGlobal of
  Just n, Nothing -> NumberState n
  Nothing, Just n -> NumberState n
  Nothing, Nothing -> NumberState zero
  Just _, Just n -> NumberState n

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

type CfgView =
  { min :: Number
  , max :: Number
  , step :: Number
  }

view :: forall html. IDHtml html => CfgView -> NumberState -> html NumberMsg
view
  { min, max, step }
  (NumberState value) =
  withCtx \_ ->
    let
      el = styleElems "InteractiveData.DataUIs.Number#view"
        { root: C.div /\
            [ "display: flex"
            , "flex-direction: row"
            , "align-items: center"
            , "justify-content: space-between"
            , "gap: 10px"
            ]
        , slider: C.div /\
            [ "flex: 3" ]
        , input: C.div /\
            [ "flex: 1" ]
        }

    in
      el.root_
        [ el.slider_
            [ UI.Slider.view
                { min
                , max
                , step
                , value
                , onChange: SetNumber
                }
            ]
        , el.input_
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
  { text :: Maybe String
  , min :: Number
  , max :: Number
  , step :: Number
  , init :: Maybe Number
  }

defaultCfgNumber :: CfgNumber
defaultCfgNumber =
  { text: Nothing
  , min: -100.0
  , max: 100.0
  , step: 1.0
  , init: Nothing
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
            , text: cfg.text
            }
      , extract
      , update: update (pick cfg)
      , init: init { initCfg: cfg.init }
      }

number_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs NumberMsg NumberState Number
number_ = number {}