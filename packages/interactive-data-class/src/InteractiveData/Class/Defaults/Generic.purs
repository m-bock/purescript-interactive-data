module InteractiveData.Class.Defaults.Generic
  ( class DefaultGeneric
  , defaultGeneric_
  , class DefaultGenericPartial
  , defaultGenericPartial_
  ) where

import Prelude

import Data.Either (Either(..))
import DataMVC.Types (DataUI)
import DataMVC.Types.DataUI (refineDataUi)
import DataMVC.Variant.DataUI (class DataUiVariant)
import Heterogeneous.Mapping (class HMap, hmap)
import InteractiveData.Class.InitDataUI (class InitGenericSpec, initGenericSpec)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs.Generic (DefaultTransform, MappingHlistToRecord(..))
import InteractiveData.DataUIs.Variant (VariantMsg, VariantState)
import InteractiveData.DataUIs.Variant as VUI
import LabeledData.VariantLike.Generic (class GenericVariantLike)
import LabeledData.VariantLike.Generic as LD
import Prim.Row as Row
import Record as Record
import Type.Proxy (Proxy(..))

--------------------------------------------------------------------------------
--- DefaultGeneric
--------------------------------------------------------------------------------

class
  DefaultGeneric
    (initcase :: Symbol)
    (token :: Type)
    (html :: Type -> Type)
    (fm :: Type -> Type)
    (fs :: Type -> Type)
    (msg :: Type)
    (sta :: Type)
    (typ :: Type)
  | token -> initcase fm fs html msg sta typ
  where
  defaultGeneric_
    :: token
    -> Proxy initcase
    -> String
    -> DataUI (IDSurface html) fm fs msg sta typ

instance
  ( GenericVariantLike DefaultTransform typ row
  , InitGenericSpec token row specs
  , DataUiVariant specs fm fs (IDSurface html) initcase rcase rmsg rsta row
  , IDHtml html
  ) =>
  DefaultGeneric initcase token html fm fs (VariantMsg rcase rmsg) (VariantState rsta) typ

  where
  defaultGeneric_
    :: token
    -> Proxy initcase
    -> String
    -> DataUI (IDSurface html) fm fs (VariantMsg rcase rmsg) (VariantState rsta) typ
  defaultGeneric_ token _ typeName =
    let
      specs :: Record specs
      specs = initGenericSpec @token @row token Proxy
    in
      specs
        # VUI.variant_ @initcase
        # refineDataUi
            { typeName
            , refine: LD.genericFromVariant (Proxy :: _ DefaultTransform) >>> Right
            , unrefine: LD.genericToVariant (Proxy :: _ DefaultTransform)
            }

--------------------------------------------------------------------------------
--- DefaultGenericPartial
--------------------------------------------------------------------------------

class
  DefaultGenericPartial
    (initcase :: Symbol)
    (token :: Type)
    (datauisPart :: Row Type)
    (html :: Type -> Type)
    (fm :: Type -> Type)
    (fs :: Type -> Type)
    (msg :: Type)
    (sta :: Type)
    (typ :: Type)
  | token -> initcase fm fs html msg sta typ
  where
  defaultGenericPartial_
    :: token
    -> Proxy initcase
    -> String
    -> Record datauisPart
    -> DataUI (IDSurface html) fm fs msg sta typ

instance
  ( Row.Union datauisPart datauis datauisAll
  , GenericVariantLike DefaultTransform typ row
  , InitGenericSpec token row datauis
  , DataUiVariant datauis fm fs (IDSurface html) initcase rcase rmsg rsta row
  , IDHtml html
  , Row.Nub datauisAll datauis
  , HMap MappingHlistToRecord (Record datauisPartH) (Record datauisPart)
  ) =>
  DefaultGenericPartial initcase token datauisPartH html fm fs (VariantMsg rcase rmsg) (VariantState rsta) typ

  where
  defaultGenericPartial_
    :: token
    -> Proxy initcase
    -> String
    -> Record datauisPartH
    -> DataUI (IDSurface html) fm fs (VariantMsg rcase rmsg) (VariantState rsta) typ
  defaultGenericPartial_ token _ typeName datauisGiven =
    let
      specsGiven' :: Record datauisPart
      specsGiven' =
        hmap MappingHlistToRecord datauisGiven

      specsInit :: Record datauis
      specsInit = initGenericSpec @token @row token Proxy

      specs :: Record datauis
      specs = Record.merge specsGiven' specsInit
    in
      specs
        # VUI.variant_ @initcase
        # refineDataUi
            { typeName
            , refine: LD.genericFromVariant (Proxy :: _ DefaultTransform) >>> Right
            , unrefine: LD.genericToVariant (Proxy :: _ DefaultTransform)
            }
