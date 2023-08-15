module InteractiveData.Class
  ( Tok
  , class IDDataUI
  , dataUi
  , recordPartial_
  ) where

import Data.Maybe (Maybe)
import Data.Variant (Variant)
import DataMVC.Types (DataUI)
import InteractiveData.Class.Defaults
  ( class DefaultGeneric
  , class DefaultRecord
  , class DefaultRecordPartial
  , class DefaultVariant
  , defaultGeneric_
  , defaultRecord
  , defaultRecordPartial_
  , defaultVariant
  )
import InteractiveData.Class.InitDataUI (class Init)
import InteractiveData.Core (class IDHtml, IDSurface)
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

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs D.StringMsg D.StringState String
  where
  dataUi = D.string_

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs D.IntMsg D.IntState Int
  where
  dataUi = D.int_

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs D.BooleanMsg D.BooleanState Boolean
  where
  dataUi = D.boolean_

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs D.NumberMsg D.NumberState Number
  where
  dataUi = D.number_

instance
  ( DefaultRecord Tok html fm fs rmsg rsta row
  ) =>
  IDDataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)
  where
  dataUi = defaultRecord Tok

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

--------------------------------------------------------------------------------
--- Partial
--------------------------------------------------------------------------------

recordPartial_
  :: forall html fm fs rmsg rsta row datauisGiven
   . DefaultRecordPartial Tok datauisGiven html fm fs rmsg rsta row
  => Record datauisGiven
  -> DataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)
recordPartial_ = defaultRecordPartial_ Tok

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
