module InteractiveData.Class.Defaults.GetDataUIs
  ( class GetDataUIs
  ) where

import DataMVC.Types (DataUI)
import Prim.Row as Row
import Prim.RowList (RowList)
import Prim.RowList as RL

class
  GetDataUIs
    (rmsg :: Row Type)
    (rsta :: Row Type)
    (rowlist :: RowList Type)
    (datauis :: Row Type)
  | rowlist rmsg rsta -> datauis

instance GetDataUIs rmsg rsta RL.Nil ()

instance
  ( GetDataUIs rmsg rsta rowlistPrev datauisPrev
  , Row.Cons sym (DataUI srf fm fs msg sta typ) datauisPrev datauis
  , Row.Lacks sym datauisPrev
  ) =>
  GetDataUIs rmsg rsta (RL.Cons sym typ rowlistPrev) datauis