module InteractiveData.Class.InitDataUI
  ( class GetInitSym
  , class GetInitSymRL
  , class Init
  , class InitGenericSpec
  , class InitGenericSpecRL
  , class InitRecord
  , class InitRecordRL
  , init
  , initGenericSpec
  , initGenericSpecRL
  , initRecord
  , initRecordRL
  ) where

import Data.Symbol (class IsSymbol)
import DataMVC.Record.DataUI (class DataUiRecord)
import DataMVC.Types (DataUI)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs (record, record_)
import InteractiveData.DataUIs.Record as R
import MVC.Record (RecordMsg, RecordState)
import Prim.Row as Row
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import Record as Record
import Type.Proxy (Proxy(..))

--------------------------------------------------------------------------------
--- Init
--------------------------------------------------------------------------------

class
  Init
    (token :: Type)
    (a :: Type)
  where
  init :: token -> a

--------------------------------------------------------------------------------
--- InitRecord
--------------------------------------------------------------------------------

class
  InitRecord
    (token :: Type)
    (row :: Row Type)
    (datauis :: Row Type)
  | token row -> datauis
  where
  initRecord :: token -> Proxy row -> Record datauis

instance
  ( RowToList row rowlist
  , InitRecordRL rowlist token datauis
  ) =>
  InitRecord token row datauis
  where
  initRecord :: token -> Proxy row -> Record datauis
  initRecord token _ = initRecordRL @rowlist token Proxy

--------------------------------------------------------------------------------
--- InitRecordRL
--------------------------------------------------------------------------------

class
  InitRecordRL
    (rowlist :: RowList Type)
    (token :: Type)
    (datauis :: Row Type)
  | rowlist token -> datauis
  where
  initRecordRL :: token -> Proxy rowlist -> Record datauis

instance InitRecordRL RL.Nil token ()
  where
  initRecordRL :: token -> Proxy RL.Nil -> Record ()
  initRecordRL _ _ = {}

instance
  ( InitRecordRL rowlistPrev tok datauisPrev
  , Row.Cons sym (DataUI (IDSurface srf) fm fs msg sta typ) datauisPrev datauis
  , Init tok (DataUI (IDSurface srf) fm fs msg sta typ)
  , IsSymbol sym
  , Row.Lacks sym datauisPrev
  ) =>
  InitRecordRL (RL.Cons sym typ rowlistPrev) tok datauis
  where
  initRecordRL :: tok -> Proxy (RL.Cons sym typ rowlistPrev) -> Record datauis
  initRecordRL tok _ =
    Record.insert prxSym dataUi tail
    where
    dataUi :: DataUI (IDSurface srf) fm fs msg sta typ
    dataUi = init tok

    tail :: { | datauisPrev }
    tail = initRecordRL @rowlistPrev tok Proxy

    prxSym :: Proxy sym
    prxSym = Proxy

--------------------------------------------------------------------------------
--- InitGenericSpec
--------------------------------------------------------------------------------

class
  InitGenericSpec
    (token :: Type)
    (row :: Row Type)
    (specs :: Row Type)
  | row token -> specs
  where
  initGenericSpec :: token -> Proxy row -> Record specs

instance
  ( RowToList row rowlist
  , InitGenericSpecRL token rowlist specs
  ) =>
  InitGenericSpec token row specs
  where
  initGenericSpec :: token -> Proxy row -> Record specs
  initGenericSpec token Proxy = initGenericSpecRL @token @rowlist token Proxy

--------------------------------------------------------------------------------
--- InitGenericSpecRL
--------------------------------------------------------------------------------

class
  InitGenericSpecRL
    (token :: Type)
    (rowlist :: RowList Type)
    (specs :: Row Type)
  | rowlist token -> specs
  where
  initGenericSpecRL :: token -> Proxy rowlist -> Record specs

instance InitGenericSpecRL token RL.Nil () where
  initGenericSpecRL :: token -> Proxy RL.Nil -> Record ()
  initGenericSpecRL _ _ = {}

instance
  ( InitGenericSpecRL token rowlistPrev specsPrev
  , Row.Cons sym (DataUI (IDSurface html) fm fs (RecordMsg rmsg) (RecordState rsta) (Record r)) specsPrev specs
  , InitRecord token typ productSpec
  , IsSymbol sym
  , Row.Lacks sym specsPrev
  , DataUiRecord productSpec fm fs (IDSurface html) rmsg rsta r
  , IDHtml html
  ) =>
  InitGenericSpecRL token (RL.Cons sym (Record typ) rowlistPrev) specs
  where
  initGenericSpecRL :: token -> Proxy (RL.Cons sym (Record typ) rowlistPrev) -> Record specs
  initGenericSpecRL token _ =
    Record.insert prxSym headVal' tail
    where

    tail :: { | specsPrev }
    tail = initGenericSpecRL @token @rowlistPrev token Proxy

    headVal :: Record productSpec
    headVal = initRecord @token @typ token Proxy

    headVal' :: DataUI (IDSurface html) fm fs (RecordMsg rmsg) (RecordState rsta) (Record r)
    headVal' = record { mode: R.Indices } headVal

    prxSym :: Proxy sym
    prxSym = Proxy

--------------------------------------------------------------------------------
--- GetInitSym
--------------------------------------------------------------------------------

class
  GetInitSym
    (row :: Row Type)
    (initSym :: Symbol)
  | row -> initSym

instance (GetInitSymRL rowlist initSym) => GetInitSym row initSym

class
  GetInitSymRL
    (rowlist :: RowList Type)
    (initSym :: Symbol)
  | rowlist -> initSym

instance GetInitSymRL (RL.Cons initSym typ rowlistPrev) initSym