module InteractiveData.Class
  ( Tok(..)
  , class IDDataUI
  , dataUi
  ) where

import Data.Either (Either)
import Data.Maybe (Maybe)
import Data.Tuple (Tuple)
import Data.Variant (Variant)
import DataMVC.Types (DataUI)
import InteractiveData.Class.Defaults
  ( class DefaultGeneric
  , class DefaultRecord
  , class DefaultVariant
  , defaultGeneric_
  , defaultRecord
  , defaultVariant
  )
import InteractiveData.Class.InitDataUI (class Init)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs (ArrayMsg, ArrayState, array_)
import InteractiveData.DataUIs as D
import Type.Proxy (Proxy(..))

class
  IDDataUI
    (srf :: Type -> Type)
    (fm :: Type -> Type)
    (fs :: Type -> Type)
    (msg :: Type)
    (sta :: Type)
    (a :: Type)
  | a -> msg sta
  where
  dataUi :: DataUI srf fm fs msg sta a

-------------------------------------------------------------------------------
--- String
-------------------------------------------------------------------------------

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs D.StringMsg D.StringState String
  where
  dataUi = D.string_

-------------------------------------------------------------------------------
--- Int
-------------------------------------------------------------------------------

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs D.IntMsg D.IntState Int
  where
  dataUi = D.int_

-------------------------------------------------------------------------------
--- Boolean
-------------------------------------------------------------------------------

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs D.BooleanMsg D.BooleanState Boolean
  where
  dataUi = D.boolean_

-------------------------------------------------------------------------------
--- Number
-------------------------------------------------------------------------------

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs D.NumberMsg D.NumberState Number
  where
  dataUi = D.number_

-------------------------------------------------------------------------------
--- Record
-------------------------------------------------------------------------------

instance
  ( DefaultRecord Tok html fm fs rmsg rsta row
  ) =>
  IDDataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)
  where
  dataUi = defaultRecord Tok

-------------------------------------------------------------------------------
--- Variant
-------------------------------------------------------------------------------

instance
  ( DefaultVariant Tok html fm fs rcase rmsg rsta row
  ) =>
  IDDataUI (IDSurface html) fm fs (D.VariantMsg rcase rmsg) (D.VariantState rsta) (Variant row)
  where
  dataUi = defaultVariant Tok

-------------------------------------------------------------------------------
--- Maybe
-------------------------------------------------------------------------------

instance
  ( DefaultGeneric "Nothing" Tok html fm fs msg sta (Maybe a)
  ) =>
  IDDataUI (IDSurface html) fm fs msg sta (Maybe a)
  where
  dataUi = defaultGeneric_ @"Nothing" Tok Proxy "Maybe"

-------------------------------------------------------------------------------
--- Either
-------------------------------------------------------------------------------

instance
  ( DefaultGeneric "Left" Tok html fm fs msg sta (Either a b)
  ) =>
  IDDataUI (IDSurface html) fm fs msg sta (Either a b)
  where
  dataUi = defaultGeneric_ @"Left" Tok Proxy "Either"

--------------------------------------------------------------------------------
--- Tuple
--------------------------------------------------------------------------------

instance
  ( DefaultGeneric "Tuple" Tok html fm fs msg sta (Tuple a b)
  ) =>
  IDDataUI (IDSurface html) fm fs msg sta (Tuple a b)
  where
  dataUi = defaultGeneric_ @"Tuple" Tok Proxy "Tuple"

--------------------------------------------------------------------------------
--- Array
--------------------------------------------------------------------------------

instance
  ( IDHtml html
  , IDDataUI (IDSurface html) fm fs msg sta a
  ) =>
  IDDataUI (IDSurface html) fm fs (ArrayMsg (fm msg)) (ArrayState (fs sta)) (Array a)
  where
  dataUi = array_ dataUi

--------------------------------------------------------------------------------
--- Tok
--------------------------------------------------------------------------------

data Tok = Tok

instance
  IDDataUI srf fm fs msg sta a =>
  Init Tok (DataUI srf fm fs msg sta a)
  where
  init :: Tok -> DataUI srf fm fs msg sta a
  init _ = dataUi
