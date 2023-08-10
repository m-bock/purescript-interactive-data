module Demo.Common.VariantJ
  ( VariantJ(..)
  , class VEncodeJsonRL
  , vEncodeJsonRL
  ) where

import Prelude

import Data.Argonaut (class EncodeJson, Json, encodeJson)
import Data.Newtype (class Newtype)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Data.Variant (Variant)
import Data.Variant as V
import Data.Variant.Internal (VariantRep(..))
import Prim.Row as Row
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import Type.Proxy (Proxy(..))

-- | Newtype wrapper for 'Variant' that has a 'Show' instance and an 'EncodeJson' instance.
-- | We need this only because we're using those instances in the example.
newtype VariantJ v = VariantJ (Variant v)

derive instance Newtype (VariantJ v) _

derive newtype instance Show (Variant v) => Show (VariantJ v)

instance
  ( VEncodeJsonRL rowlist row
  , RowToList row rowlist
  ) =>
  EncodeJson (VariantJ row)
  where
  encodeJson :: VariantJ row -> Json
  encodeJson (VariantJ variant) = vEncodeJsonRL @rowlist Proxy variant

--------------------------------------------------------------------------------
--- VEncodeJsonRL
--------------------------------------------------------------------------------

class
  VEncodeJsonRL
    (rowlist :: RowList Type)
    (row :: Row Type)
  | rowlist -> row
  where
  vEncodeJsonRL :: Proxy rowlist -> Variant row -> Json

instance VEncodeJsonRL RL.Nil ()
  where
  vEncodeJsonRL :: Proxy RL.Nil -> Variant () -> Json
  vEncodeJsonRL Proxy = V.case_

instance
  ( VEncodeJsonRL rowlistPrev rowPrev
  , Row.Cons sym typ rowPrev row
  , IsSymbol sym
  , EncodeJson typ
  ) =>
  VEncodeJsonRL (RL.Cons sym typ rowlistPrev) row
  where
  vEncodeJsonRL :: Proxy (RL.Cons sym typ rowlistPrev) -> Variant row -> Json
  vEncodeJsonRL Proxy =
    V.on
      (Proxy @sym)
      encodeHead
      tail

    where
    encodeHead :: typ -> Json
    encodeHead value =
      let
        tag :: String
        tag = reflectSymbol (Proxy @sym)

        rep :: VariantRep typ
        rep = VariantRep { type: tag, value }
      in
        case rep of
          VariantRep repRecord ->
            encodeJson repRecord

    tail :: Variant rowPrev -> Json
    tail = vEncodeJsonRL @rowlistPrev Proxy
