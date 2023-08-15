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

--------------------------------------------------------------------------------
--- GetDataUIsGen
--------------------------------------------------------------------------------

class
  InitDataUIsGeneric (row :: Row Type) (datauis :: Row Type)
  where
  getDataUIsGen :: Record row -> Record datauis

-------------------------------------------------------------------------------
--- InitADTSpec
-------------------------------------------------------------------------------

-- class InitADTSpec :: Row Type -> Type -> Row Type -> Constraint
-- class InitADTSpec r tok specs | r tok -> specs where
--   initADTSpec :: tok -> Proxy r -> Record specs

-- instance (InitADTSpecRL rl tok datauis, RowToList r rl) => InitADTSpec r tok datauis where
--   initADTSpec tok _ = initADTSpecRL tok prxRl
--     where
--     prxRl = Proxy :: _ rl

---

-- class InitADTSpecRL :: RowList Type -> Type -> Row Type -> Constraint
-- class InitADTSpecRL rl tok specs | rl tok -> specs where
--   initADTSpecRL :: tok -> Proxy rl -> Record specs

-- instance InitADTSpecRL RL.Nil tok () where
--   initADTSpecRL _ _ = {}

-- instance
--   ( InitADTSpecRL rl' tok cases'
--   , Row.Cons sym (DataUI (IDSurface html) (D.RecordMsg rmsg) (D.RecordState rsta) (Record r)) cases' cases

--   , InitRecord r tok datauis
--   , DataUiRecord datauis WrapMsg WrapState (IDSurface html) rmsg rsta r
--   , IDHtml html

--   , IsSymbol sym
--   , Row.Lacks sym cases'
--   ) =>
--   InitADTSpecRL (RL.Cons sym (Record r) rl') tok cases where
--   initADTSpecRL tok _ =
--     Record.insert prxSym dataUi tail
--     where

--     mapError :: IDError -> IDError
--     mapError (IDError dataPath errorCase) =
--       case Array.uncons dataPath of
--         Just { head: SegField (SegStaticKey key), tail } ->
--           let
--             n :: Int
--             n = String.drop 1 key
--               # Int.fromString
--               # fromMaybe 0

--           in
--             IDError ([ SegField (SegStaticIndex n) ] <> tail) errorCase
--         _ -> IDError dataPath errorCase

--     dataUi :: IDDataUI html (ID.RecordMsg rmsg) (ID.RecordState rsta) (Record r)
--     dataUi =
--       dataUis
--         # ID.dataUiRecord'
--             { mkSegment: \ix _ -> SegStaticIndex (ix + 1)
--             }

--         # refineDataUi
--             { typeName: "Fields"
--             , refine: Right
--             , unrefine: identity
--             }
--         # mapErrors
--             (map mapError)

--     tail :: { | cases' }
--     tail = initADTSpecRL tok prxRl'

--     dataUis :: Record datauis
--     dataUis = initRecord tok prxR

--     prxRl' = Proxy :: _ rl'
--     prxR = Proxy :: _ r
--     prxSym = Proxy :: _ sym