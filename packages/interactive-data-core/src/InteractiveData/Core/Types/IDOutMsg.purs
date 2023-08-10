module InteractiveData.Core.Types.IDOutMsg
  ( IDOutMsg(..)
  )
  where

import Prelude

--------------------------------------------------------------------------------
--- Types
--------------------------------------------------------------------------------

data IDOutMsg =
  GlobalSelectDataPath (Array String)

--------------------------------------------------------------------------------
--- Instances
--------------------------------------------------------------------------------

derive instance Ord IDOutMsg
derive instance Eq IDOutMsg
