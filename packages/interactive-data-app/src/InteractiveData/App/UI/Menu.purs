module InteractiveData.App.UI.Menu
  ( MenuMsg
  , MenuSelfMsg(..)
  , MenuState(..)
  , ViewCfg
  , init
  , update
  , view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Data.Array (mapWithIndex)
import Data.Array as Array
import Data.Map (Map)
import Data.Map as Map
import Data.Monoid (guard)
import Data.Tuple (fst)
import InteractiveData.App.UI.Assets as UI.Assets
import InteractiveData.App.UI.DataLabel as UIDataLabel
import InteractiveData.App.UI.Types.SumTree (SumTree(..), treeIsLeaf)
import InteractiveData.Core.Types.DataPathExtra (dataPathToStrings)
import InteractiveData.Core.Types.DataTree (TreeMeta)

-------------------------------------------------------------------------------
--- Types
-------------------------------------------------------------------------------

newtype MenuState = MenuState
  { expandMap :: Map DataPath Boolean
  }

type MenuMsg msg = These MenuSelfMsg msg

data MenuSelfMsg = SetExpanded Unit DataPath Boolean

-------------------------------------------------------------------------------
--- Update
-------------------------------------------------------------------------------

update :: MenuSelfMsg -> MenuState -> MenuState
update msg (MenuState state) = case msg of
  SetExpanded _ path val ->
    MenuState state { expandMap = Map.insert path val state.expandMap }

-------------------------------------------------------------------------------
--- Init
-------------------------------------------------------------------------------

init :: MenuState
init = MenuState { expandMap: Map.empty }

-------------------------------------------------------------------------------
--- View
-------------------------------------------------------------------------------

type ViewCfg msg =
  { onSelectPath :: Array String -> msg
  , tree :: SumTree
  }

view :: forall html msg. IDHtml html => ViewCfg msg -> MenuState -> html (MenuMsg msg)
view props@{ onSelectPath } state =
  viewTree
    { viewRow:
        viewRow
          { onSetExpanded: \path val ->
              This $ SetExpanded unit path val
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
    el = styleElems "InteractiveData.App.UI.Menu#viewLabel"
      { label: C.div /\
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
                    [ UIDataLabel.view
                        { dataPath:
                            { before: []
                            , path: pathAbs
                            }
                        , mkTitle: UIDataLabel.mkTitleGoto
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
viewTree cfg { path, tree } =
  let
    SumTree { children } = tree
    el = styleElems "InteractiveData.App.UI.Menu#viewTree"
      { item: C.div
      , sub: C.div /\
          [ "padding-left: 15px" ]
      , root: C.div /\
          [ "padding: 5px" ]
      }

  in
    el.root []
      ( children #
          map \({ key, deepSingletons, tree: tree' }) ->
            let
              newPath = path <> [ key ] <> map fst deepSingletons
              isExpanded = cfg.pathIsExpanded newPath
              isLeaf = treeIsLeaf tree'
              SumTree { meta: meta } = tree'

            in
              el.item []
                [ cfg.viewRow
                    { path: newPath
                    , isExpanded
                    , isLeaf
                    , viewLabel: cfg.viewLabel { path, label: [ key /\ meta ] <> deepSingletons }
                    , meta
                    }
                , if isExpanded then
                    el.sub []
                      [ viewTree cfg { path: newPath, tree: tree' }
                      ]
                  else
                    C.noHtml
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
viewRow { onSetExpanded } opts@{ path, isExpanded, isLeaf } =
  let
    el = styleElems "InteractiveData.App.UI.Menu#viewRow"
      { root: C.div /\
          [ "display: flex; "
          , "align-items: center"
          , "padding: 5px"
          , "gap: 3px"
          ]
      , icon: C.div /\
          [ "cursor: pointer"
          , "width: 20px"
          , "height: 20px"
          , guard isExpanded "transform: rotate(90deg)"
          , "transition: transform 100ms ease-in-out"
          , "display: flex"
          , "align-items: center"
          , "justify-content: center"
          ]
      , iconInner: C.div /\
          [ "width: 6px"
          , "display: flex"
          , "align-items: center"
          , "justify-content: center"
          ]
      , iconDash: C.div /\
          [ "width: 10px"
          , "display: flex"
          , "align-items: center"
          , "justify-content: center"
          ]
      , label: C.div
      }

  in
    el.root_
      [ el.icon
          [ if isLeaf then C.noProp
            else C.onClick (onSetExpanded path (not isExpanded))
          ]
          [ if isLeaf then
              el.iconDash_
                [ UI.Assets.viewDash ]
            else
              el.iconInner_
                [ UI.Assets.viewChevronRight ]
          ]
      , el.label_ [ opts.viewLabel ]
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