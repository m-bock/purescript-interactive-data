module InteractiveData.Class.Init
  ( class HInit
  , class Init
  , class HInitRecordRL
  , hinit
  , init
  , hInitRecordRL
  ) where

import Data.Symbol (class IsSymbol)
import Prim.Row as Row
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import Record as Record
import Type.Proxy (Proxy(..))
import InteractiveData.DataUIs.Generic (Product(..))

class
  HInit
    (token :: Type)
    (a :: Type)
  where
  hinit :: token -> a

instance
  ( HInitRecordRL token rowlist row
  , RowToList row rowlist
  ) =>
  HInit token (Record row) where
  hinit :: token -> Record row
  hinit token = hInitRecordRL @token @rowlist token Proxy

--------------------------------------------------------------------------------
--- Init
--------------------------------------------------------------------------------

class
  Init
    (token :: Type)
    (a :: Type)
  where
  init :: token -> a

instance
  ( Init token a
  , Init token b
  ) =>
  Init token (Product a b)
  where
  init :: token -> Product a b
  init token = Product (init token) (init token)

--------------------------------------------------------------------------------
--- HInitRecordRL
--------------------------------------------------------------------------------

class
  HInitRecordRL
    (token :: Type)
    (rowlist :: RowList Type)
    (row :: Row Type)
  | token rowlist -> row
  where
  hInitRecordRL :: token -> Proxy rowlist -> Record row

instance HInitRecordRL token RL.Nil () where
  hInitRecordRL :: token -> Proxy RL.Nil -> Record ()
  hInitRecordRL _ _ = {}

instance
  ( HInitRecordRL token rowlistPrev rowPrev
  , Init token typ
  , IsSymbol sym
  , Row.Cons sym typ rowPrev row
  , Row.Lacks sym rowPrev
  ) =>
  HInitRecordRL token (RL.Cons sym typ rowlistPrev) row
  where
  hInitRecordRL :: token -> Proxy (RL.Cons sym typ rowlistPrev) -> Record row
  hInitRecordRL token _ =
    let
      tail :: Record rowPrev
      tail = hInitRecordRL @token @rowlistPrev token Proxy

      headVal :: typ
      headVal = init token

      proxySym :: Proxy sym
      proxySym = Proxy

    in
      Record.insert proxySym headVal tail
