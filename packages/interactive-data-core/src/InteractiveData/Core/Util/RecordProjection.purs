module InteractiveData.Core.Util.RecordProjection
  ( Prj
  , class Project
  , pick
  )
  where

import Data.Symbol (class IsSymbol)
import Heterogeneous.Folding (class FoldingWithIndex, class HFoldlWithIndex, hfoldlWithIndex)
import Prim.Row as Row
import Prim.RowList (class RowToList)
import Record as Record
import Type.Proxy (Proxy(..))

data Prj r = Prj r

instance
  ( IsSymbol sym
  , Row.Lacks sym acc1
  , Row.Cons sym ty acc1 acc2
  , Row.Cons sym ty inp' inp
  ) =>
  FoldingWithIndex (Prj { | inp }) (Proxy sym) { | acc1 } (Proxy ty) { | acc2 }
  where
  foldingWithIndex (Prj inp) sym acc _ =
    Record.insert sym (Record.get sym inp) acc

class Project a b where
  pick :: a -> b

instance projectRecord ::
  ( RowToList r2 rl
  , HFoldlWithIndex (Prj { | r1 }) {} (Proxy rl) { | r2 }
  ) =>
  Project { | r1 } { | r2 } where
  pick inp = hfoldlWithIndex (Prj inp) {} (Proxy :: Proxy rl)
