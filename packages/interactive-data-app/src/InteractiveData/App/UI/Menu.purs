module InteractiveData.App.UI.Menu
  ( MenuMsg
  , MenuSelfMsg(..)
  , MenuState(..)
  , ViewMenuCfg
  , initMenu
  , updateMenu
  , viewMenu
  ) where

import InteractiveData.Core.Prelude

import Data.Array (mapWithIndex)
import Data.Array as Array
import Data.Map (Map)
import Data.Map as Map
import Data.Tuple (fst)
import DataMVC.Types (DataPath, DataPathSegment(..), DataPathSegmentField(..))
import InteractiveData.App.UI.DataLabel (mkTitleGoto, viewDataLabel)
import InteractiveData.App.UI.Menu.Row (viewRow)
import InteractiveData.App.UI.Menu.Tree (viewTree)
import InteractiveData.App.UI.Menu.Types (SumTree)
import InteractiveData.Core (class IDHtml)
import InteractiveData.Core.Types.DataPathExtra (dataPathToStrings)
import InteractiveData.Core.Types.DataTree (TreeMeta)
import VirtualDOM as VD
import VirtualDOM.Styled (styleNode)

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

newtype MenuState = MenuState
  { expandMap :: Map DataPath Boolean
  }

type MenuMsg msg = These MenuSelfMsg msg

data MenuSelfMsg = SetExpandend Unit DataPath Boolean

-------------------------------------------------------------------------------
--- Update
-------------------------------------------------------------------------------

updateMenu :: MenuSelfMsg -> MenuState -> MenuState
updateMenu msg (MenuState state) = case msg of
  SetExpandend _ path val ->
    MenuState state { expandMap = Map.insert path val state.expandMap }

-------------------------------------------------------------------------------
--- Init
-------------------------------------------------------------------------------

initMenu :: MenuState
initMenu = MenuState { expandMap: Map.empty }

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

type ViewMenuCfg msg =
  { onSelectPath :: Array String -> msg
  , tree :: SumTree
  }

viewMenu :: forall html msg. IDHtml html => ViewMenuCfg msg -> MenuState -> html (MenuMsg msg)
viewMenu props@{ onSelectPath } state =
  viewTree
    { viewRow:
        viewRow
          { onSetExpanded: \path val ->
              This $ SetExpandend unit path val
          }
    , viewLabel: viewLabel { onSelectPath: onSelectPath >>> That }
    , pathIsExpanded: pathIsExpanded state
    }
    { path: []
    , tree: props.tree
    }

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

viewLabel
  :: forall html msg
   . IDHtml html
  => { onSelectPath :: Array String -> msg }
  -> { path :: Array DataPathSegment, label :: Array (DataPathSegment /\ TreeMeta) }
  -> html msg
viewLabel { onSelectPath } { path, label } =
  let
    el =
      { label: styleNode VD.div
          [ "cursor: pointer"
          , "display: flex"
          , "gap: 4px"
          , "align-items: center;"
          ]
      }
  in
    el.label []
      ( label
          # initsWithItem
          # Array.take 1
          # map
              ( \(init' /\ _) ->
                  let
                    pathRel = map fst init' :: DataPath
                    pathAbs = path <> pathRel :: DataPath

                  in
                    [ viewDataLabel
                        { dataPath:
                            { before: []
                            , path: pathAbs
                            }
                        , mkTitle: mkTitleGoto
                        }
                        { onHit: Just (onSelectPath $ dataPathToStrings pathAbs)
                        , isSelected: true
                        }
                    ]
              )
          # join
      )

-------------------------------------------------------------------------------
--- Utils
-------------------------------------------------------------------------------

segmentToName :: DataPathSegment -> String
segmentToName = case _ of
  SegCase _ -> "Case"
  SegField x -> case x of
    SegStaticKey _ -> "static key"
    SegStaticIndex _ -> "static index"
    SegDynamicKey _ -> "dynamic key"
    SegDynamicIndex _ -> "dynamic index"
    SegVirtualKey _ -> "virtual key"

pathIsExpanded :: MenuState -> DataPath -> Boolean
pathIsExpanded (MenuState state) path = case Map.lookup path state.expandMap of
  Nothing -> false
  Just x -> x

initsWithItem :: forall a. Array a -> Array (Array a /\ a)
initsWithItem xs = mapWithIndex (\ix x -> Array.take (ix + 1) xs /\ x) xs