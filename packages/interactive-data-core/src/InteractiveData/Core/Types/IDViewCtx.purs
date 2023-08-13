module InteractiveData.Core.Types.IDViewCtx
  ( IDViewCtx
  , ViewMode(..)
  , defaultViewCtx
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Tuple.Nested (type (/\), (/\))
import DataMVC.Types (DataPath)
import InteractiveData.Core.Types.DataTree (TreeMeta)

--------------------------------------------------------------------------------
--- Types
--------------------------------------------------------------------------------

type IDViewCtx =
  { path :: DataPath
  , selectedPath :: DataPath
  , viewMode :: ViewMode
  , root :: String /\ TreeMeta
  , fullscreen :: Boolean
  , fastForward :: Boolean
  , showLogo :: Boolean
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
  , fullscreen: true
  , fastForward: true
  , showLogo: true
  }

--------------------------------------------------------------------------------
--- Instances
--------------------------------------------------------------------------------

instance Monoid ViewMode where
  mempty = Standalone

instance Semigroup ViewMode where
  append x _ = x