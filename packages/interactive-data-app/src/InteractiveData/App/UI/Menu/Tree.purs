module InteractiveData.App.UI.Menu.Tree where

import InteractiveData.Core.Prelude

import Data.Tuple (fst)
import DataMVC.Types (DataPath, DataPathSegment)
import InteractiveData.App.UI.Menu.Row (ViewRowOpts)
import InteractiveData.App.UI.Menu.Types (SumTree(..), treeIsLeaf)
import InteractiveData.Core (class IDHtml)
import InteractiveData.Core.Types.DataTree (TreeMeta)
import VirtualDOM as VD
import VirtualDOM.Styled (styleNode)

type ViewTreeCfg :: (Type -> Type) -> Type -> Type
type ViewTreeCfg html msg =
  { pathIsExpanded ::
      DataPath -> Boolean
  , viewRow :: ViewRowOpts html msg -> html msg
  , viewLabel :: { path :: Array DataPathSegment, label :: Array (DataPathSegment /\ TreeMeta) } -> html msg

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
      , root: VD.div
      }

  in
    el.root []
      ( children #
          map \({ key, deepSingletons, tree: tree' }) ->
            let
              newPath = path <> [ key ] <> map fst deepSingletons
              isExpanded = pathIsExpanded newPath
              isLeaf = treeIsLeaf tree'
              SumTree { meta: meta@{ errored } } = tree'

            in
              el.item []
                [ viewRow
                    { path: newPath
                    , isExpanded
                    , isLeaf
                    , viewLabel: viewLabel { path, label: [ key /\ meta ] <> deepSingletons }
                    , meta
                    }
                , case isExpanded of
                    true ->
                      el.sub []
                        [ viewTree cfg { path: newPath, tree: tree' }
                        ]
                    false -> VD.noHtml
                ]

      )
