module InteractiveData.DataUIs.Boolean
  ( BooleanMsg
  , BooleanState
  , CfgBoolean
  , boolean
  , boolean_
  , defaultCfgBoolean
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import InteractiveData.App.UI.DataLabel as UIDataLabel

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

data BooleanMsg
  = SetBoolean Boolean
  | Toggle

newtype BooleanState = BooleanState Boolean

derive newtype instance Show BooleanState

-------------------------------------------------------------------------------
--- Extract
-------------------------------------------------------------------------------

extract :: BooleanState -> DataResult Boolean
extract (BooleanState s) = Right s

-------------------------------------------------------------------------------
--- Init
-------------------------------------------------------------------------------

init :: Maybe Boolean -> BooleanState
init optStr = BooleanState $ fromMaybe false optStr

-------------------------------------------------------------------------------
--- Update
-------------------------------------------------------------------------------

update
  :: BooleanMsg
  -> BooleanState
  -> BooleanState
update msg (BooleanState state) =
  case msg of
    SetBoolean newBoolean -> BooleanState newBoolean
    Toggle -> BooleanState $ not state

-------------------------------------------------------------------------------
--- View
-------------------------------------------------------------------------------

view :: forall html. IDHtml html => BooleanState -> html BooleanMsg
view (BooleanState value) =
  withCtx \ctx ->
    let
      el = styleElems "InteractiveData.DataUIs.Boolean#view"
        { caseLabels: C.div
            /\
              [ "display: flex"
              , "flex-direction: column"
              , "gap: 5px"
              , "margin-bottom: 15px"
              ]
            /\ case ctx.viewMode of
              Inline -> "flex-direction: column"
              Standalone -> "flex-direction: row"
        , caseLabel: unit
        }
    in
      el.caseLabels_
        [ el.caseLabel_
            [ UIDataLabel.view
                { dataPath:
                    { before: []
                    , path: ctx.path <> [ SegCase "true" ]
                    }
                , mkTitle: UIDataLabel.mkTitleSelect
                }
                { isSelected: value
                , onHit: Just $ SetBoolean true
                }
            ]
        , el.caseLabel_
            [ UIDataLabel.view
                { dataPath:
                    { before: []
                    , path: ctx.path <> [ SegCase "false" ]
                    }
                , mkTitle: UIDataLabel.mkTitleSelect
                }
                { isSelected: not value
                , onHit: Just $ SetBoolean false
                }
            ]
        ]

-------------------------------------------------------------------------------
--- DataActions
-------------------------------------------------------------------------------

actions :: Array (DataAction BooleanMsg)
actions =
  [ DataAction
      { description: "Toggle"
      , label: "Toggle"
      , msg: This $ Toggle
      }
  ]

-------------------------------------------------------------------------------
--- DataUI
-------------------------------------------------------------------------------

type CfgBoolean =
  { text :: Maybe String
  }

defaultCfgBoolean :: CfgBoolean
defaultCfgBoolean =
  { text: Nothing
  }

boolean
  :: forall opt html fm fs
   . OptArgs CfgBoolean opt
  => IDHtml html
  => opt
  -> DataUI (IDSurface html) fm fs BooleanMsg BooleanState Boolean
boolean opt =
  let
    cfg :: CfgBoolean
    cfg = getAllArgs defaultCfgBoolean opt

  in
    DataUI \_ -> DataUiInterface
      { name: "Boolean"
      , view: \state -> IDSurface \_ ->
          DataTree
            { view: view state
            , actions
            , children: Fields []
            , meta: Nothing
            , text: cfg.text
            }
      , extract
      , update
      , init
      }

boolean_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs BooleanMsg BooleanState Boolean
boolean_ = boolean {}