module InteractiveData.DataUIs.StyledExtra
  ( class StyledElems
  , styledElems
  , class StyledElemsRL
  , styledElemsRL
  , class StyledElemsOne
  , styledElemsOne
  ) where

import Prelude

import Chameleon (Key, Prop)
import Chameleon.Styled (class HtmlStyled, class IsStyle, styleKeyedNode, styleLeaf, styleNode)
import Data.Symbol (class IsSymbol)
import Data.Tuple.Nested (type (/\), (/\))
import Prim.Row as Row
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import Record as Record
import Type.Proxy (Proxy(..))

class
  StyledElems
    (rowIn :: Row Type)
    (rowOut :: Row Type)
  | rowIn -> rowOut
  where
  styledElems :: String -> Record rowIn -> Record rowOut

instance
  ( RowToList rowIn rowlist
  , StyledElemsRL rowlist rowIn rowOut
  ) =>
  StyledElems rowIn rowOut
  where
  styledElems _ = styledElemsRL (Proxy :: Proxy rowlist)

--------------------------------------------------------------------------------

class
  StyledElemsRL
    (rowlist :: RowList Type)
    (rowIn :: Row Type)
    (rowOut :: Row Type)
  | rowlist rowIn -> rowOut
  where
  styledElemsRL :: Proxy rowlist -> Record rowIn -> Record rowOut

instance StyledElemsRL RL.Nil row () where
  styledElemsRL _ _ = {}

instance
  ( StyledElemsRL rowlistPrev rowIn rowOutPrev
  , Row.Cons sym typ rowTrash rowIn
  , Row.Cons sym styledElem rowOutPrev rowOut
  , Row.Lacks sym rowOutPrev
  , StyledElemsOne typ styledElem
  , IsSymbol sym
  ) =>
  StyledElemsRL
    (RL.Cons sym typ rowlistPrev)
    rowIn
    rowOut
  where
  styledElemsRL
    :: Proxy (RL.Cons sym typ rowlistPrev)
    -> Record rowIn
    -> Record rowOut
  styledElemsRL _ recordIn =
    let
      recordPrev :: Record rowOutPrev
      recordPrev = styledElemsRL (Proxy :: Proxy rowlistPrev) recordIn

      spec :: typ
      spec = Record.get proxySym recordIn

      styledElem :: styledElem
      styledElem = styledElemsOne spec

      proxySym :: Proxy sym
      proxySym = Proxy
    in
      Record.insert proxySym styledElem recordPrev

--------------------------------------------------------------------------------

class
  StyledElemsOne
    (typ :: Type)
    (styledElem :: Type)
  | typ -> styledElem
  where
  styledElemsOne :: typ -> styledElem

instance
  StyledElemsOne
    (Array (Prop a) -> html a)
    (Array (Prop a) -> html a)
  where
  styledElemsOne = identity

else instance
  StyledElemsOne
    (Array (Prop a) -> Array (html a) -> html a)
    (Array (Prop a) -> Array (html a) -> html a)
  where
  styledElemsOne = identity

else instance
  StyledElemsOne
    (Array (Prop a) -> Array (Key /\ html a) -> html a)
    (Array (Prop a) -> Array (Key /\ html a) -> html a)
  where
  styledElemsOne = identity

instance
  ( IsStyle style
  , HtmlStyled html
  ) =>
  StyledElemsOne
    ((Array (Prop a) -> html a) /\ style)
    (Array (Prop a) -> html a)
  where
  styledElemsOne (elem /\ style) =
    styleLeaf elem style

else instance
  ( IsStyle style
  , HtmlStyled html
  ) =>
  StyledElemsOne
    ((Array (Prop a) -> Array (html a) -> html a) /\ style)
    (Array (Prop a) -> Array (html a) -> html a)
  where
  styledElemsOne (elem /\ style) =
    styleNode elem style

else instance
  ( IsStyle style
  , HtmlStyled html
  ) =>
  StyledElemsOne
    ((Array (Prop a) -> Array (Key /\ html a) -> html a) /\ style)
    (Array (Prop a) -> Array (Key /\ html a) -> html a)
  where
  styledElemsOne (elem /\ style) =
    styleKeyedNode elem style

else instance
  ( IsStyle style
  , HtmlStyled html
  ) =>
  StyledElemsOne
    ((Array (Prop a) -> Array (Key /\ html a) -> html a) /\ style)
    (Array (Prop a) -> Array (Key /\ html a) -> html a)
  where
  styledElemsOne (elem /\ style) =
    styleKeyedNode elem style