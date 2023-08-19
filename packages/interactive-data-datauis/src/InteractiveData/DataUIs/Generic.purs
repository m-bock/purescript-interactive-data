module InteractiveData.DataUIs.Generic
  ( (~)
  , DefaultTransform
  , MappingHlistToRecord(..)
  , Product(..)
  , class GenericDataUI
  , class HlistToRecord
  , generic
  , hlistToRecord
  , type (~)
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Symbol (class IsSymbol)
import DataMVC.Record.DataUI (class DataUiRecord)
import DataMVC.Types (DataUI)
import DataMVC.Types.DataUI (refineDataUi)
import DataMVC.Variant.DataUI (class DataUiVariant)
import Heterogeneous.Mapping (class HMap, class Mapping, hmap)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.Core.Classes.OptArgs (class OptArgs, getAllArgs)
import InteractiveData.DataUIs.Record (RecordMsg, RecordState, record)
import InteractiveData.DataUIs.Record as R
import InteractiveData.DataUIs.Variant as VUI
import LabeledData.TransformEntry.Transforms (ArgsToRecord, NoTransform)
import LabeledData.VariantLike.Generic (class GenericVariantLike)
import LabeledData.VariantLike.Generic as LD
import MVC.Variant (VariantMsg, VariantState)
import Prim.Int (class ToString, class Add)
import Prim.Row as Row
import Record as Record
import Type.Proxy (Proxy(..))

type IDDataUIGeneric html fm fs rcase rmsg rsta a = DataUI html fm fs (VariantMsg rcase rmsg) (VariantState rsta) a

type CfgGeneric =
  { text :: Maybe String
  }

defaultCfg :: CfgGeneric
defaultCfg =
  { text: Nothing
  }

class
  GenericDataUI
    (opt :: Type)
    (html :: Type -> Type)
    (fm :: Type -> Type)
    (fs :: Type -> Type)
    (initcase :: Symbol)
    (datauis :: Row Type)
    (msg :: Type)
    (sta :: Type)
    (a :: Type)
  | datauis opt -> initcase html fm fs datauis msg sta a
  where
  generic :: { typeName :: String } -> opt -> { | datauis } -> DataUI (IDSurface html) fm fs msg sta a

instance
  ( DataUiVariant datauis fm fs (IDSurface html) initcase rcase rmsg rsta r
  , IDHtml html
  , GenericVariantLike DefaultTransform a r
  , HMap MappingHlistToRecord (Record datauisHlist) (Record datauis)
  , OptArgs CfgGeneric opt
  ) =>
  GenericDataUI
    opt
    html
    fm
    fs
    initcase
    datauisHlist
    (VariantMsg rcase rmsg)
    (VariantState rsta)
    a
  where
  generic
    :: { typeName :: String }
    -> opt
    -> { | datauisHlist }
    -> DataUI (IDSurface html) fm fs (VariantMsg rcase rmsg) (VariantState rsta) a
  generic { typeName } opt uisHlist =
    let
      cfg :: CfgGeneric
      cfg = getAllArgs defaultCfg opt
    in

      uisHlist
        # hmap MappingHlistToRecord
        # VUI.variant @initcase { text: cfg.text }
        # refineDataUi
            { typeName
            , refine: LD.genericFromVariant (Proxy :: _ DefaultTransform) >>> Right
            , unrefine: LD.genericToVariant (Proxy :: _ DefaultTransform)
            }

--------------------------------------------------------------------------------
--- LabeledData config
--------------------------------------------------------------------------------

type DefaultTransform = ArgsToRecord NoTransform

--------------------------------------------------------------------------------
--- Product Syntax
--------------------------------------------------------------------------------

data Product a b = Product a b

infixr 6 Product as ~

infixr 6 type Product as ~

--------------------------------------------------------------------------------
--- MappingHlistToRecord
--------------------------------------------------------------------------------

data MappingHlistToRecord = MappingHlistToRecord

instance
  ( HlistToRecord 1 hlist datauis
  , DataUiRecord datauis fm fs (IDSurface html) rmsg rsta row
  , IDHtml html
  ) =>
  Mapping MappingHlistToRecord hlist (DataUI (IDSurface html) fm fs (RecordMsg rmsg) (RecordState rsta) (Record row))
  where
  mapping
    :: MappingHlistToRecord -> hlist -> DataUI (IDSurface html) fm fs (RecordMsg rmsg) (RecordState rsta) (Record row)
  mapping MappingHlistToRecord hlist =
    record { mode: R.Indices } rec
    where
    rec :: Record datauis
    rec = hlistToRecord (Proxy :: _ 1) hlist

--------------------------------------------------------------------------------
--- HlistToRecord
--------------------------------------------------------------------------------

class
  HlistToRecord (count :: Int) hl (r :: Row Type)
  | hl -> r
  where
  hlistToRecord :: Proxy count -> hl -> Record r

instance HlistToRecord count Unit () where
  hlistToRecord _ _ = {}

else instance
  ( HlistToRecord countNext as rowPrev
  , Add count 1 countNext
  , ToString count sym
  , IsSymbol sym
  , Row.Lacks sym rowPrev
  , Row.Cons sym a rowPrev row
  ) =>
  HlistToRecord count (a ~ as) row
  where
  hlistToRecord _ (hlHead ~ hlTail) =
    Record.insert sym hlHead recordTail
    where
    recordTail :: Record rowPrev
    recordTail = hlistToRecord prxCountNext hlTail

    sym :: Proxy sym
    sym = Proxy

    prxCountNext :: Proxy countNext
    prxCountNext = Proxy

else instance
  ( Row.Cons sym a () row
  , ToString count sym
  , IsSymbol sym
  ) =>
  HlistToRecord count a row
  where
  hlistToRecord _ head = Record.insert prxSym head {}
    where
    prxSym :: Proxy sym
    prxSym = Proxy
