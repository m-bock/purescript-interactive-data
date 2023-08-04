module InteractiveData.Core.Types.DataAction
  ( DataAction(..)
  ) where

import Prelude

import Data.These (These)
import InteractiveData.Core.Types.IDOutMsg (IDOutMsg)

--------------------------------------------------------------------------------
--- Types
--------------------------------------------------------------------------------

newtype DataAction msg = DataAction
  { label :: String
  , description :: String
  , msg :: These msg IDOutMsg
  }

--------------------------------------------------------------------------------
--- Instances
--------------------------------------------------------------------------------

derive instance Functor DataAction
derive instance Eq msg => Eq (DataAction msg)
derive instance Ord msg => Ord (DataAction msg)
