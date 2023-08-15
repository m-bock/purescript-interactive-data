module InteractiveData.Class.Defaults.Variant
  ( class DefaultVariant
  , defaultVariant
  , class DefaultVariantPartial
  , defaultVariantPartial_
  ) where

import Data.Variant (Variant)
import DataMVC.Types (DataUI)
import DataMVC.Variant.DataUI (class DataUiVariant)
import InteractiveData.Class.InitDataUI (class GetInitSym, class InitRecord, initRecord)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs as D
import Prim.Row as Row
import Record as Record
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

--------------------------------------------------------------------------------
--- DefaultRecordPartial
--------------------------------------------------------------------------------

class
  DefaultVariantPartial
    (token :: Type)
    (datauisPart :: Row Type)
    (html :: Type -> Type)
    (fm :: Type -> Type)
    (fs :: Type -> Type)
    (initsym :: Symbol)
    (rcase :: Row Type)
    (rmsg :: Row Type)
    (rsta :: Row Type)
    (row :: Row Type)
  where
  defaultVariantPartial_
    :: token
    -> Proxy initsym
    -> Record datauisPart
    -> DataUI (IDSurface html) fm fs (D.VariantMsg rcase rmsg) (D.VariantState rsta) (Variant row)

instance
  ( Row.Union datauisGiven datauis datauisAll
  , InitRecord token row datauis
  , DataUiVariant datauis fm fs (IDSurface html) initsym rcase rmsg rsta row
  , IDHtml html
  , Row.Nub datauisAll datauis
  ) =>
  DefaultVariantPartial token datauisGiven html fm fs initsym rcase rmsg rsta row
  where
  defaultVariantPartial_
    :: token
    -> Proxy initsym
    -> Record datauisGiven
    -> DataUI (IDSurface html) fm fs (D.VariantMsg rcase rmsg) (D.VariantState rsta) (Variant row)
  defaultVariantPartial_ token _ datauisGiven =
    let
      dataUisInit :: Record datauis
      dataUisInit = initRecord @token @row token Proxy

      dataUis :: Record datauis
      dataUis = Record.merge datauisGiven dataUisInit
    in
      D.variant_ dataUis
