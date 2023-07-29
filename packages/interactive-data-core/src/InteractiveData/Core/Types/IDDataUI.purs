module InteractiveData.Core.Types.IDDataUI
  ( IDSurface(..)
  , IDSurfaceCtx
  , mapErrors
  , runIdSurface
  ) where

import Prelude

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Bifunctor (lmap)
import Data.Newtype (class Newtype)
import DataMVC.Types (DataPath, DataUI(..), DataUICtx, DataUiItf(..))
import DataMVC.Types.DataError (DataError)
import InteractiveData.Core.Types.DataTree (DataTree)

--------------------------------------------------------------------------------
--- Types
--------------------------------------------------------------------------------

newtype IDSurface html msg =
  IDSurface (IDSurfaceCtx -> DataTree html msg)

type IDSurfaceCtx =
  { path :: DataPath }

--------------------------------------------------------------------------------
--- Destructors
--------------------------------------------------------------------------------

runIdSurface
  :: forall html msg
   . IDSurfaceCtx
  -> IDSurface html msg
  -> DataTree html msg
runIdSurface x (IDSurface f) = f x

--------------------------------------------------------------------------------
--- Combinators
--------------------------------------------------------------------------------

mapErrors
  :: forall html fm fs msg sta a
   . (NonEmptyArray DataError -> NonEmptyArray DataError)
  -> DataUI (IDSurface html) fm fs msg sta a
  -> DataUI (IDSurface html) fm fs msg sta a
mapErrors f (DataUI mkDataUi) = DataUI \ctx ->
  let
    DataUiItf { init, extract, name, update, view } = mkDataUi ctx
  in
    DataUiItf
      { extract: extract >>> lmap f
      , init
      , name
      , update
      , view
      }

--------------------------------------------------------------------------------
--- Instances
--------------------------------------------------------------------------------

derive instance Functor html => Functor (IDSurface html)
derive instance Newtype (IDSurface html msg) _

