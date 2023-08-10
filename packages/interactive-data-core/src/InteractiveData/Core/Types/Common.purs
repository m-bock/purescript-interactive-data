module InteractiveData.Core.Types.Common
  ( PathInContext
  , unPathInContext
  ) where

import Prelude

type PathInContext a =
  { before :: Array a
  , path :: Array a
  }

unPathInContext :: forall a. PathInContext a -> Array a
unPathInContext x = x.before <> x.path
