module InteractiveData.Core.Types.IDDataUI
  ( IDDataUI
  , IDDataUICtx
  , IDSurface(..)
  , IDSurfaceCtx
  , WrapMsg(..)
  , WrapState(..)
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

type IDDataUI html msg sta a =
  DataUI
    (IDSurface html)
    WrapMsg
    WrapState
    msg
    sta
    a

newtype IDSurface html msg =
  IDSurface (IDSurfaceCtx -> DataTree html msg)

type IDDataUICtx html =
  DataUICtx (IDSurface html) WrapMsg WrapState

type IDSurfaceCtx =
  { path :: DataPath }

newtype WrapState sta = WrapState
  { childState :: sta }

data WrapMsg msg = ChildMsg msg

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
  :: forall html msg sta a
   . (NonEmptyArray DataError -> NonEmptyArray DataError)
  -> IDDataUI html msg sta a
  -> IDDataUI html msg sta a
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

derive instance Eq sta => Eq (WrapState sta)