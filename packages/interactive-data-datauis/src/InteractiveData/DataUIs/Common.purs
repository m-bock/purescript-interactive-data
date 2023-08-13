module InteractiveData.DataUIs.Common
  ( maybe
  ) where

import Data.Maybe (Maybe)
import DataMVC.Types (DataUI)
import InteractiveData.Core (IDSurface)
import InteractiveData.DataUIs.Generic (class GenericDataUI, genericDataUI)

maybe
  :: forall html fm fs datauis msg sta a
   . GenericDataUI html fm fs "Nothing" datauis msg sta (Maybe a)
  => { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Maybe a)
maybe = genericDataUI
  { typeName: "Maybe"
  }

