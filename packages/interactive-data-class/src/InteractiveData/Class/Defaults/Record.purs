module InteractiveData.Class.Defaults.Record
  ( class DefaultRecord
  , defaultRecord
  ) where

import DataMVC.Record.DataUI (class DataUiRecord)
import DataMVC.Types (DataUI)
import InteractiveData.Class.Defaults.GetDataUIs (class GetDataUIs)
import InteractiveData.Class.Init (class HInit, hinit)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs as D
import Prim.RowList (class RowToList)

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
  , HInit token (Record datauis)
  , RowToList row rowlist
  , GetDataUIs rmsg rsta rowlist datauis
  ) =>
  DefaultRecord token html fm fs rmsg rsta row
  where
  defaultRecord :: token -> DataUI (IDSurface html) fm fs (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)
  defaultRecord token =
    let
      dataUis :: Record datauis
      dataUis = hinit token
    in
      D.record_ dataUis

