module InteractiveData.DataUIs.Common
  ( either_
  , maybe_
  , tuple_
  ) where

import Data.Either (Either)
import Data.Maybe (Maybe)
import Data.Tuple (Tuple)
import DataMVC.Types (DataUI)
import InteractiveData.Core (IDSurface)
import InteractiveData.DataUIs.Generic (class GenericDataUI, generic)

maybe_
  :: forall html fm fs datauis msg sta a
   . GenericDataUI html fm fs "Nothing" datauis msg sta (Maybe a)
  => { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Maybe a)
maybe_ = generic
  { typeName: "Maybe"
  }

either_
  :: forall html fm fs datauis msg sta a b
   . GenericDataUI html fm fs "Left" datauis msg sta (Either a b)
  => { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Either a b)
either_ = generic
  { typeName: "Either"
  }

tuple_
  :: forall html fm fs datauis msg sta a b
   . GenericDataUI html fm fs "Tuple" datauis msg sta (Tuple a b)
  => { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Tuple a b)
tuple_ = generic
  { typeName: "Tuple"
  }

