module InteractiveData.Class
  ( Tok(..)
  , class IDDataUI
  , dataUi
  ) where

import Chameleon (class Html)
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
import InteractiveData.Core (IDSurface)
import InteractiveData.DataUIs (ArrayMsg, ArrayState, array_)
import InteractiveData.DataUIs as D
import InteractiveData.Core.Types.IDHtmlT (IDHtmlT)
import Prelude as P
import Type.Proxy (Proxy(..))

class
  IDDataUI
    (html :: Type -> Type)
    (fm :: Type -> Type)
    (fs :: Type -> Type)
    (msg :: Type)
    (sta :: Type)
    (a :: Type)
  | a -> msg sta
  where
  dataUi :: DataUI (IDSurface (IDHtmlT html)) fm fs msg sta a

-------------------------------------------------------------------------------
--- String
-------------------------------------------------------------------------------

instance
  Html html =>
  IDDataUI html fm fs D.StringMsg D.StringState String
  where
  dataUi = D.string_

-------------------------------------------------------------------------------
--- Int
-------------------------------------------------------------------------------

instance
  Html html =>
  IDDataUI html fm fs D.IntMsg D.IntState Int
  where
  dataUi = D.int_

-------------------------------------------------------------------------------
--- Boolean
-------------------------------------------------------------------------------

instance
  Html html =>
  IDDataUI html fm fs D.BooleanMsg D.BooleanState Boolean
  where
  dataUi = D.boolean_

-------------------------------------------------------------------------------
--- Number
-------------------------------------------------------------------------------

instance
  Html html =>
  IDDataUI html fm fs D.NumberMsg D.NumberState Number
  where
  dataUi = D.number_

-------------------------------------------------------------------------------
--- Unit
-------------------------------------------------------------------------------

instance
  Html html =>
  IDDataUI html fm fs P.Unit P.Unit P.Unit
  where
  dataUi = D.unit_

-------------------------------------------------------------------------------
--- Record
-------------------------------------------------------------------------------

instance
  ( DefaultRecord Tok html fm fs rmsg rsta row
  ) =>
  IDDataUI html fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)
  where
  dataUi = defaultRecord Tok

-------------------------------------------------------------------------------
--- Variant
-------------------------------------------------------------------------------

instance
  ( DefaultVariant Tok html fm fs rcase rmsg rsta row
  ) =>
  IDDataUI html fm fs (D.VariantMsg rcase rmsg) (D.VariantState rsta) (Variant row)
  where
  dataUi = defaultVariant Tok

-------------------------------------------------------------------------------
--- Maybe
-------------------------------------------------------------------------------

instance
  ( DefaultGeneric "Nothing" Tok html fm fs msg sta (Maybe a)
  ) =>
  IDDataUI html fm fs msg sta (Maybe a)
  where
  dataUi = defaultGeneric_ @"Nothing" Tok Proxy "Maybe"

-------------------------------------------------------------------------------
--- Either
-------------------------------------------------------------------------------

instance
  ( DefaultGeneric "Left" Tok html fm fs msg sta (Either a b)
  ) =>
  IDDataUI html fm fs msg sta (Either a b)
  where
  dataUi = defaultGeneric_ @"Left" Tok Proxy "Either"

--------------------------------------------------------------------------------
--- Tuple
--------------------------------------------------------------------------------

instance
  ( DefaultGeneric "Tuple" Tok html fm fs msg sta (Tuple a b)
  ) =>
  IDDataUI html fm fs msg sta (Tuple a b)
  where
  dataUi = defaultGeneric_ @"Tuple" Tok Proxy "Tuple"

--------------------------------------------------------------------------------
--- Array
--------------------------------------------------------------------------------

instance
  ( Html html
  , IDDataUI html fm fs msg sta a
  ) =>
  IDDataUI html fm fs (ArrayMsg (fm msg)) (ArrayState (fs sta)) (Array a)
  where
  dataUi = array_ dataUi

--------------------------------------------------------------------------------
--- Tok
--------------------------------------------------------------------------------

data Tok = Tok

instance
  IDDataUI html fm fs msg sta a =>
  Init Tok (DataUI (IDSurface (IDHtmlT html)) fm fs msg sta a)
  where
  init :: Tok -> DataUI (IDSurface (IDHtmlT html)) fm fs msg sta a
  init _ = dataUi
