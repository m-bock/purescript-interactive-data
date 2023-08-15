module InteractiveData.Class.Defaults.Variant
  ( class DefaultVariant
  , defaultVariant
  ) where

import Data.Variant (Variant)
import DataMVC.Types (DataUI)
import DataMVC.Variant.DataUI (class DataUiVariant)
import InteractiveData.Class.InitDataUI (class GetInitSym, class InitRecord, initRecord)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs as D
import Type.Proxy (Proxy(..))

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
  , InitRecord token row datauis
  , GetInitSym row initSym
  ) =>
  DefaultVariant token html fm fs rcase rmsg rsta row
  where
  defaultVariant :: token -> DataUI (IDSurface html) fm fs (D.VariantMsg rcase rmsg) (D.VariantState rsta) (Variant row)
  defaultVariant token =
    let
      dataUis :: Record datauis
      dataUis = initRecord @token @row token Proxy
    in
      D.variant_ dataUis

