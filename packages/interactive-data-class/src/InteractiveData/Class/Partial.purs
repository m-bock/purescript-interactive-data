module InteractiveData.Class.Partial
  ( genericPartial_
  , recordPartial
  , recordPartial_
  , variantPartial_
  ) where

import Data.Variant (Variant)
import DataMVC.Types (DataUI)
import InteractiveData.Class (Tok(..))
import InteractiveData.Class.Defaults
  ( class DefaultGenericPartial
  , class DefaultRecordPartial
  , class DefaultVariantPartial
  , defaultGenericPartial_
  , defaultRecordPartial
  )
import InteractiveData.Class.Defaults.Variant (defaultVariantPartial_)
import InteractiveData.Core (IDSurface)
import InteractiveData.DataUIs as D
import Type.Proxy (Proxy(..))

--------------------------------------------------------------------------------
--- Partial
--------------------------------------------------------------------------------

recordPartial
  :: forall opt html fm fs rmsg rsta row datauisGiven
   . DefaultRecordPartial Tok opt datauisGiven html fm fs rmsg rsta row
  => opt
  -> Record datauisGiven
  -> DataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)
recordPartial = defaultRecordPartial Tok

recordPartial_
  :: forall html fm fs rmsg rsta row datauisGiven
   . DefaultRecordPartial Tok {} datauisGiven html fm fs rmsg rsta row
  => Record datauisGiven
  -> DataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)
recordPartial_ = recordPartial {}

variantPartial_
  :: forall html fm fs @initsym rcase rmsg rsta row datauisGiven
   . DefaultVariantPartial Tok datauisGiven html fm fs initsym rcase rmsg rsta row
  => Record datauisGiven
  -> DataUI (IDSurface html) fm fs (D.VariantMsg rcase rmsg) (D.VariantState rsta) (Variant row)
variantPartial_ = defaultVariantPartial_ Tok (Proxy :: Proxy initsym)

genericPartial_
  :: forall html fm fs @initsym msg sta a datauisGiven
   . DefaultGenericPartial initsym Tok datauisGiven html fm fs msg sta a
  => String
  -> Record datauisGiven
  -> DataUI (IDSurface html) fm fs msg sta a
genericPartial_ = defaultGenericPartial_ Tok (Proxy :: Proxy initsym)
