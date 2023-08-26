module InteractiveData.DataUIs.Newtype
  ( newtype_
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Newtype (class Newtype)
import Data.Newtype as Newtype
import DataMVC.Types.DataUI (DataUI(..), refineDataUi, runDataUi)
import InteractiveData.DataUIs.Types (TypeName(..))

newtype_
  :: forall srf fm fs msg sta a b
   . Newtype b a
  => TypeName
  -> DataUI srf fm fs msg sta a
  -> DataUI srf fm fs msg sta b
newtype_ (TypeName typeName) dataUi = DataUI \ctx ->
  let
    newDataUi :: DataUI srf fm fs msg sta b
    newDataUi =
      refineDataUi
        { typeName
        , refine: Newtype.wrap >>> Right
        , unrefine: Newtype.unwrap
        }
        dataUi
  in
    runDataUi newDataUi ctx
