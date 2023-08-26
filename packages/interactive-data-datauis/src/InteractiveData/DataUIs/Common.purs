module InteractiveData.DataUIs.Common
  ( either
  , either_
  , maybe
  , maybe_
  , mkEither
  , mkEither_
  , mkMaybe
  , mkMaybe_
  , tuple
  , tuple_
  ) where

import Prelude

import Data.Either (Either)
import Data.Maybe (Maybe)
import Data.Tuple (Tuple)
import DataMVC.Types (DataUI)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.Core.Classes.OptArgs (class OptArgs)
import InteractiveData.DataUIs.Generic (class GenericDataUI, CfgGeneric, TypeName(..), generic, (~))

--------------------------------------------------------------------------------
--- Maybe
--------------------------------------------------------------------------------

mkMaybe
  :: forall opt html datauis fm fs msg sta a
   . GenericDataUI "Nothing" opt html datauis fm fs msg sta (Maybe a)
  => opt
  -> { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Maybe a)
mkMaybe = generic
  (TypeName "Maybe")

mkMaybe_
  :: forall html datauis fm fs msg sta a
   . GenericDataUI "Nothing" {} html datauis fm fs msg sta (Maybe a)
  => { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Maybe a)
mkMaybe_ = mkMaybe {}

maybe_
  :: forall html a
   . IDHtml html
  => DataUI (IDSurface html) _ _ _ _ a
  -> DataUI (IDSurface html) _ _ _ _ (Maybe a)
maybe_ = maybe {}

maybe
  :: forall opt html a
   . IDHtml html
  => OptArgs CfgGeneric opt
  => opt
  -> DataUI (IDSurface html) _ _ _ _ a
  -> DataUI (IDSurface html) _ _ _ _ (Maybe a)
maybe opt x = mkMaybe
  opt
  { "Just": x
  , "Nothing": unit
  }

--------------------------------------------------------------------------------
--- Either
--------------------------------------------------------------------------------

mkEither
  :: forall opt html datauis fm fs msg sta a b
   . GenericDataUI "Left" opt html datauis fm fs msg sta (Either a b)
  => opt
  -> { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Either a b)
mkEither = generic
  (TypeName "Either")

mkEither_
  :: forall html datauis fm fs msg sta a b
   . GenericDataUI "Left" {} html datauis fm fs msg sta (Either a b)
  => { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Either a b)
mkEither_ = mkEither {}

either_
  :: forall html a b
   . IDHtml html
  => DataUI (IDSurface html) _ _ _ _ a
  -> DataUI (IDSurface html) _ _ _ _ b
  -> DataUI (IDSurface html) _ _ _ _ (Either a b)
either_ = either {}

either
  :: forall opt html a b
   . IDHtml html
  => OptArgs CfgGeneric opt
  => opt
  -> DataUI (IDSurface html) _ _ _ _ a
  -> DataUI (IDSurface html) _ _ _ _ b
  -> DataUI (IDSurface html) _ _ _ _ (Either a b)
either opt x y = mkEither
  opt
  { "Left": x
  , "Right": y
  }

--------------------------------------------------------------------------------
--- Tuple
--------------------------------------------------------------------------------

mkTuple
  :: forall opt html datauis fm fs msg sta a b
   . GenericDataUI "Tuple" opt html datauis fm fs msg sta (Tuple a b)
  => opt
  -> { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta (Tuple a b)
mkTuple = generic
  (TypeName "Tuple")

tuple_
  :: forall html a b
   . IDHtml html
  => DataUI (IDSurface html) _ _ _ _ a
  -> DataUI (IDSurface html) _ _ _ _ b
  -> DataUI (IDSurface html) _ _ _ _ (Tuple a b)
tuple_ = tuple {}

tuple
  :: forall opt html a b
   . IDHtml html
  => OptArgs CfgGeneric opt
  => opt
  -> DataUI (IDSurface html) _ _ _ _ a
  -> DataUI (IDSurface html) _ _ _ _ b
  -> DataUI (IDSurface html) _ _ _ _ (Tuple a b)
tuple opt x y = mkTuple
  opt
  { "Tuple": x ~ y }