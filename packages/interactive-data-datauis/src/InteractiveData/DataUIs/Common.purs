module InteractiveData.DataUIs.Common
  ( either
  , either_
  , maybe
  , maybe_
  , tuple
  , tuple_
  ) where

import Data.Either (Either)
import Data.Maybe (Maybe)
import Data.Tuple (Tuple)
import DataMVC.Types (DataUI)
import InteractiveData.Core (IDSurface)
import InteractiveData.DataUIs.Generic (class GenericDataUI, generic)

--------------------------------------------------------------------------------
--- Maybe
--------------------------------------------------------------------------------

maybe
  :: forall opt html fm fs datauis msg sta a
   . GenericDataUI opt html fm fs "Nothing" datauis msg sta (Maybe a)
  => opt
  -> { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Maybe a)
maybe = generic
  { typeName: "Maybe"
  }

maybe_
  :: forall html fm fs datauis msg sta a
   . GenericDataUI {} html fm fs "Nothing" datauis msg sta (Maybe a)
  => { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Maybe a)
maybe_ = maybe {}

--------------------------------------------------------------------------------
--- Either
--------------------------------------------------------------------------------

either
  :: forall opt html fm fs datauis msg sta a b
   . GenericDataUI opt html fm fs "Left" datauis msg sta (Either a b)
  => opt
  -> { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Either a b)
either = generic
  { typeName: "Either"
  }

either_
  :: forall html fm fs datauis msg sta a b
   . GenericDataUI {} html fm fs "Left" datauis msg sta (Either a b)
  => { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Either a b)
either_ = either {}

--------------------------------------------------------------------------------
--- Tuple
--------------------------------------------------------------------------------

tuple
  :: forall opt html fm fs datauis msg sta a b
   . GenericDataUI opt html fm fs "Tuple" datauis msg sta (Tuple a b)
  => opt
  -> { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Tuple a b)
tuple = generic
  { typeName: "Tuple"
  }

tuple_
  :: forall html fm fs datauis msg sta a b
   . GenericDataUI {} html fm fs "Tuple" datauis msg sta (Tuple a b)
  => { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Tuple a b)
tuple_ = tuple {}
