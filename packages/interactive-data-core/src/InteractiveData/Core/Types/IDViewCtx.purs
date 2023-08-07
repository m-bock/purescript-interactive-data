module InteractiveData.Core.Types.IDViewCtx
  ( IDViewCtx
  , PathInContext
  , ViewMode(..)
  , defaultViewCtx
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Tuple.Nested (type (/\), (/\))
import DataMVC.Types (DataPath, DataPathSegment)
import InteractiveData.Core.Types.DataTree (TreeMeta)

--------------------------------------------------------------------------------
--- Types
--------------------------------------------------------------------------------

type IDViewCtx =
  { path :: DataPath
  , selectedPath :: DataPath
  , viewMode :: ViewMode
  , root :: String /\ TreeMeta
  , mapMetaAlongPath :: PathInContext DataPathSegment -> PathInContext (DataPathSegment /\ TreeMeta)
  , fullscreen :: Boolean
  , fastForward :: Boolean
  }

type PathInContext a =
  { before :: Array a
  , path :: Array a
  }

data ViewMode
  = Inline
  | Standalone

--------------------------------------------------------------------------------
--- Constructors
--------------------------------------------------------------------------------

defaultViewCtx :: { label :: String } -> IDViewCtx
defaultViewCtx { label } =
  { path: []
  , selectedPath: []
  , viewMode: Standalone
  , root: label /\ { errored: Right unit, typeName: mempty }
  , mapMetaAlongPath: \_ -> mempty
  , fullscreen: true
  , fastForward: true
  }

--------------------------------------------------------------------------------
--- Instances
--------------------------------------------------------------------------------

instance Monoid ViewMode where
  mempty = Standalone

instance Semigroup ViewMode where
  append x _ = x