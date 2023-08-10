module InteractiveData.DataUIs.Newtype
  ( newtype_
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Newtype (class Newtype)
import Data.Newtype as Newtype
import DataMVC.Types.DataUI (DataUI(..), DataUiInterface(..), refineDataUi, runDataUi)

newtype_
  :: forall srf fm fs msg sta a b
   . Newtype b a
  => DataUI srf fm fs msg sta a
  -> DataUI srf fm fs msg sta b
newtype_ dataUi@(DataUI mkDataUi) = DataUI \ctx ->
  let
    DataUiInterface { name } = mkDataUi ctx

    newDataUi :: DataUI srf fm fs msg sta b
    newDataUi =
      refineDataUi
        { typeName: name
        , refine: Newtype.wrap >>> Right
        , unrefine: Newtype.unwrap
        }
        dataUi
  in
    runDataUi newDataUi ctx
