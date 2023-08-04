module InteractiveData.App.UI.Types.SumTree
  ( SumTree(..)
  , sumTree
  , treeIsLeaf
  ) where

import InteractiveData.Core.Prelude

import Data.Traversable (for)
import InteractiveData.Core.Types.DataTree (TreeMeta, DataTree(..), DataTreeChildren(..))

--------------------------------------------------------------------------------
--- Types
--------------------------------------------------------------------------------

newtype SumTree = SumTree
  { meta :: TreeMeta
  , children ::
      Array
        { key :: DataPathSegment
        , deepSingletons :: Array (DataPathSegment /\ TreeMeta)
        , tree :: SumTree
        }
  }

--------------------------------------------------------------------------------
--- Functions
--------------------------------------------------------------------------------

-- TODO: Make tail recursive
sumTree
  :: forall srf msg
   . DataTree srf msg
  -> Maybe
       { deepSingletons :: Array (DataPathSegment /\ TreeMeta)
       , tree :: SumTree
       }
sumTree (DataTree { children, meta: meta' }) = do
  meta <- meta'

  case children of
    Case (key /\ value) -> do
      { deepSingletons, tree } <- sumTree value

      pure
        { deepSingletons: []
        , tree: SumTree
            { meta
            , children:

                [ { deepSingletons
                  , key: SegCase key
                  , tree
                  }
                ]
            }
        }
    Fields fields -> do
      children' <- for fields
        \(key /\ value) -> do

          { deepSingletons, tree } <- sumTree value

          pure { key: SegField key, deepSingletons, tree }

      pure
        { deepSingletons: []
        , tree: SumTree
            { meta
            , children: children'
            }
        }

treeIsLeaf :: SumTree -> Boolean
treeIsLeaf (SumTree { children }) = case children of
  [] -> true
  _ -> false

--------------------------------------------------------------------------------
--- Instances
--------------------------------------------------------------------------------

derive instance Generic SumTree _

instance Show SumTree where
  show x = genericShow x
