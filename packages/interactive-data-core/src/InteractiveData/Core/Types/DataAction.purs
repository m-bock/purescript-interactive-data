module InteractiveData.Core.Types.DataAction where

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

data Icon = IconUnicode Char

--------------------------------------------------------------------------------
--- Instances
--------------------------------------------------------------------------------

derive instance Eq Icon
derive instance Ord Icon

derive instance Functor DataAction
derive instance Eq msg => Eq (DataAction msg)
derive instance Ord msg => Ord (DataAction msg)
