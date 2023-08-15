module InteractiveData.Class.Defaults.Partial
  ( class DefaultRecordPartial
  , defaultRecordPartial_
  ) where

import DataMVC.Record.DataUI (class DataUiRecord)
import DataMVC.Types (DataUI)
import InteractiveData.Class.Defaults.GetDataUIs (class GetDataUIs)
import InteractiveData.Class.Init (class HInit, hinit)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs as D
import Prim.Row as Row
import Prim.RowList (class RowToList)
import Record as Record

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
    :: token -> Record datauisPart -> DataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)

instance
  ( Row.Union datauisGiven datauisInit datauis
  , HInit token (Record datauisInit)
  , Row.Nub datauis datauis
  , GetDataUIs rmsg rsta rowlist datauis
  , RowToList row rowlist
  , DataUiRecord datauis fm fs (IDSurface html) rmsg rsta row
  , IDHtml html
  ) =>
  DefaultRecordPartial token datauisGiven html fm fs rmsg rsta row
  where
  defaultRecordPartial_ token datauisPart =
    let
      dataUisInit :: Record datauisInit
      dataUisInit = hinit token

      dataUis :: Record datauis
      dataUis = Record.merge datauisPart dataUisInit
    in
      D.record_ dataUis

