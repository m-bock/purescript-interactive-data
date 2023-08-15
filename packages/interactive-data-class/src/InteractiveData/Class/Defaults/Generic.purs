module InteractiveData.Class.Defaults.Generic
  ( class DefaultGeneric
  , defaultGeneric_
  ) where

import Prelude

import Data.Either (Either(..))
import DataMVC.Types (DataUI)
import DataMVC.Types.DataUI (refineDataUi)
import DataMVC.Variant.DataUI (class DataUiVariant)
import InteractiveData.Class.InitDataUI (class InitGenericSpec, initGenericSpec)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs.Generic (DefaultTransform)
import InteractiveData.DataUIs.Variant (VariantMsg, VariantState)
import InteractiveData.DataUIs.Variant as VUI
import LabeledData.VariantLike.Generic (class GenericVariantLike)
import LabeledData.VariantLike.Generic as LD
import Type.Proxy (Proxy(..))

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
