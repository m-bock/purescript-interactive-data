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
import DataMVC.Types (DataPath, DataPathSegment)
import InteractiveData.App.UI.Assets as UI.Assets
import InteractiveData.App.UI.DataLabel (mkTitleGoto, viewDataLabel)
import InteractiveData.App.UI.Types.SumTree (SumTree(..), treeIsLeaf)
import InteractiveData.Core (class IDHtml)
import InteractiveData.Core.Types.DataPathExtra (dataPathToStrings)
import InteractiveData.Core.Types.DataTree (TreeMeta)
import VirtualDOM as VD

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
--- View
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

viewLabel
  :: forall html msg
   . IDHtml html
  => { onSelectPath :: Array String -> msg }
  -> { path :: Array DataPathSegment
     , label :: Array (DataPathSegment /\ TreeMeta)
     }
  -> html msg
viewLabel { onSelectPath } { path, label } =
  let
    el =
      { label: styleNode VD.div
          [ "cursor: pointer"
          , "display: flex"
          , "gap: 4px"
          , "align-items: center"
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
                    pathRel :: DataPath
                    pathRel = map fst init'

                    pathAbs :: DataPath
                    pathAbs = path <> pathRel
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

type ViewTreeCfg :: (Type -> Type) -> Type -> Type
type ViewTreeCfg html msg =
  { pathIsExpanded ::
      DataPath -> Boolean
  , viewRow :: ViewRowOpts html msg -> html msg
  , viewLabel ::
      { path :: Array DataPathSegment
      , label :: Array (DataPathSegment /\ TreeMeta)
      }
      -> html msg
  }

type ViewTreeOpts = { path :: DataPath, tree :: SumTree }

viewTree
  :: forall html msg
   . IDHtml html
  => ViewTreeCfg html msg
  -> ViewTreeOpts
  -> html msg
viewTree cfg@{ pathIsExpanded, viewRow, viewLabel } { path, tree } =
  let
    SumTree { children } = tree
    el =
      { item: VD.div
      , sub: styleNode VD.div
          [ "padding-left: 15px" ]
      , root: styleNode VD.div
          [ "padding: 5px" ]
      }

  in
    el.root []
      ( children #
          map \({ key, deepSingletons, tree: tree' }) ->
            let
              newPath = path <> [ key ] <> map fst deepSingletons
              isExpanded = pathIsExpanded newPath
              isLeaf = treeIsLeaf tree'
              SumTree { meta: meta } = tree'

            in
              el.item []
                [ viewRow
                    { path: newPath
                    , isExpanded
                    , isLeaf
                    , viewLabel: viewLabel { path, label: [ key /\ meta ] <> deepSingletons }
                    , meta
                    }
                , if isExpanded then
                    el.sub []
                      [ viewTree cfg { path: newPath, tree: tree' }
                      ]
                  else
                    VD.noHtml
                ]

      )

type ViewRowCfg msg =
  { onSetExpanded :: DataPath -> Boolean -> msg
  }

type ViewRowOpts (html :: Type -> Type) msg =
  { isExpanded :: Boolean
  , path :: DataPath
  , isLeaf :: Boolean
  , meta :: TreeMeta
  , viewLabel :: html msg
  }

viewRow
  :: forall html msg
   . IDHtml html
  => ViewRowCfg msg
  -> ViewRowOpts html msg
  -> html msg
viewRow { onSetExpanded } { viewLabel, path, isExpanded, isLeaf } =
  let
    el =
      { row: styleNode VD.div
          [ "display: flex; "
          , "align-items: center"
          , "padding: 5px"
          ]
      , icon: styleNode VD.div
          [ "cursor: pointer"
          , "width: 20px"
          , "height: 20px"
          , if isExpanded then "transform: rotate(90deg)" else mempty
          , "transition: transform 100ms ease-in-out"
          , "display: flex"
          , "align-items: center"
          , "justify-content: center"
          ]
      , iconInner: styleNode VD.div
          [ "height: 24px"
          , "width: 14px"
          , "scale: 0.4"
          ]
      , iconDash: styleNode VD.div
          [ "height: 20px"
          , "width: 24px"
          , "scale: 0.6"
          ]
      }

  in
    el.row []
      [ el.icon
          [ if isLeaf then VD.noProp
            else VD.onClick (onSetExpanded path (not isExpanded))
          ]
          [ if isLeaf then
              el.iconDash
                []
                [ UI.Assets.viewDash ]
            else
              el.iconInner
                []
                [ UI.Assets.viewChevronRight ]
          ]
      , viewLabel
      ]

-------------------------------------------------------------------------------
--- Utils
-------------------------------------------------------------------------------

pathIsExpanded :: MenuState -> DataPath -> Boolean
pathIsExpanded (MenuState state) path = case Map.lookup path state.expandMap of
  Nothing -> false
  Just x -> x

initsWithItem :: forall a. Array a -> Array (Array a /\ a)
initsWithItem xs = mapWithIndex (\ix x -> Array.take (ix + 1) xs /\ x) xs