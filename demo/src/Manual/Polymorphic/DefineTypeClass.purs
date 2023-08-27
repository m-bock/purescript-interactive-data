{-
# Define a custom Type Class

<!-- START hide -->
-}
module Manual.Polymorphic.DefineTypeClass where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Chameleon (class Html)
import InteractiveData (DataUI', WrapMsg, WrapState)
import InteractiveData as D
import InteractiveData.Class.Defaults (class DefaultRecord, defaultRecord)
import InteractiveData.Class.InitDataUI (class Init)

{-
<!-- END imports -->
-}

class
  MyDataUI
    (html :: Type -> Type)
    (msg :: Type)
    (sta :: Type)
    (a :: Type)
  | a -> msg sta
  where
  myDataUi :: DataUI' html msg sta a

type T = WrapMsg

{-

-}

data MyTok = MyTok

instance
  MyDataUI html msg sta a =>
  Init MyTok (DataUI' html msg sta a)
  where
  init :: MyTok -> DataUI' html msg sta a
  init _ = myDataUi

{-

-}

instance
  Html html =>
  MyDataUI html D.StringMsg D.StringState String
  where
  myDataUi = D.string_

{-
-}

instance
  ( DefaultRecord MyTok html WrapMsg WrapState rmsg rsta row
  , Html html
  ) =>
  MyDataUI html (D.RecordMsg rmsg) (D.RecordState rsta) (Record row)
  where
  myDataUi = defaultRecord MyTok

{-
-}

type Sample =
  { firstName :: String
  , lastName :: String
  , contact ::
      { address :: String
      , email :: String
      }
  }

demo :: forall html. Html html => DataUI' html _ _ Sample
demo = myDataUi

{-
<!-- START embed customClass 500 -->
<!-- END embed -->
-}