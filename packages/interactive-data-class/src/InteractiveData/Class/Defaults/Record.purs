module InteractiveData.Class.Defaults.Record
  ( class DefaultRecord
  , class DefaultRecordPartial
  , defaultRecord
  , defaultRecordPartial_
  ) where

import DataMVC.Record.DataUI (class DataUiRecord)
import DataMVC.Types (DataUI)
import InteractiveData.Class.InitDataUI (class InitRecord, initRecord)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs as D
import Prim.Row as Row
import Record as Record
import Type.Proxy (Proxy(..))

--------------------------------------------------------------------------------
--- DefaultRecord
--------------------------------------------------------------------------------

class
  DefaultRecord
    (token :: Type)
    (html :: Type -> Type)
    (fm :: Type -> Type)
    (fs :: Type -> Type)
    (rmsg :: Row Type)
    (rsta :: Row Type)
    (row :: Row Type)
  where
  defaultRecord :: token -> DataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)

instance
  ( IDHtml html
  , DataUiRecord datauis fm fs (IDSurface html) rmsg rsta row
  , InitRecord token row datauis
  ) =>
  DefaultRecord token html fm fs rmsg rsta row
  where
  defaultRecord :: token -> DataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)
  defaultRecord token =
    let
      dataUis :: Record datauis
      dataUis = initRecord @token @row token Proxy
    in
      D.record_ dataUis

--------------------------------------------------------------------------------
--- DefaultRecordPartial
--------------------------------------------------------------------------------

class
  DefaultRecordPartial
    (token :: Type)
    (datauisPart :: Row Type)
    (html :: Type -> Type)
    (fm :: Type -> Type)
    (fs :: Type -> Type)
    (rmsg :: Row Type)
    (rsta :: Row Type)
    (row :: Row Type)
  where
  defaultRecordPartial_
    :: token
    -> Record datauisPart
    -> DataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)

instance
  ( Row.Union datauisGiven datauis datauisAll
  , InitRecord token row datauis
  , DataUiRecord datauis fm fs (IDSurface html) rmsg rsta row
  , IDHtml html
  , Row.Nub datauisAll datauis
  ) =>
  DefaultRecordPartial token datauisGiven html fm fs rmsg rsta row
  where
  defaultRecordPartial_
    :: token
    -> Record datauisGiven
    -> DataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)
  defaultRecordPartial_ token datauisGiven =
    let
      dataUisInit :: Record datauis
      dataUisInit = initRecord @token @row token Proxy

      dataUis :: Record datauis
      dataUis = Record.merge datauisGiven dataUisInit
    in
      D.record_ dataUis
