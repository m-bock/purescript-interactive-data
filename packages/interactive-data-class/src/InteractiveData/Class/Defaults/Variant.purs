module InteractiveData.Class.Defaults.Variant
  ( class DefaultVariant
  , class GetInitSym
  , defaultVariant
  ) where

import Data.Variant (Variant)
import DataMVC.Types (DataUI)
import DataMVC.Variant.DataUI (class DataUiVariant)
import InteractiveData.Class.Defaults.GetDataUIs (class GetDataUIs)
import InteractiveData.Class.Init (class HInit, hinit)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs as D
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL

--------------------------------------------------------------------------------
--- DefaultVariant
--------------------------------------------------------------------------------

class
  DefaultVariant
    (token :: Type)
    (html :: Type -> Type)
    (fm :: Type -> Type)
    (fs :: Type -> Type)
    (rcase :: Row Type)
    (rmsg :: Row Type)
    (rsta :: Row Type)
    (row :: Row Type)
  where
  defaultVariant :: token -> DataUI (IDSurface html) fm fs (D.VariantMsg rcase rmsg) (D.VariantState rsta) (Variant row)

instance
  ( IDHtml html
  , DataUiVariant datauis fm fs (IDSurface html) initSym rcase rmsg rsta row
  , HInit token (Record datauis)
  , RowToList row rowlist
  , GetDataUIs rmsg rsta rowlist datauis
  , GetInitSym rowlist initSym
  ) =>
  DefaultVariant token html fm fs rcase rmsg rsta row
  where
  defaultVariant :: token -> DataUI (IDSurface html) fm fs (D.VariantMsg rcase rmsg) (D.VariantState rsta) (Variant row)
  defaultVariant token =
    let
      dataUis :: Record datauis
      dataUis = hinit token
    in
      D.variant_ dataUis

--------------------------------------------------------------------------------
--- GetInitSym
--------------------------------------------------------------------------------

class
  GetInitSym
    (rowlist :: RowList Type)
    (initSym :: Symbol)
  | rowlist -> initSym

instance GetInitSym (RL.Cons initSym typ rowlistPrev) initSym