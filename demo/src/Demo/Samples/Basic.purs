module Demo.Samples.Basic where

import Prelude

import InteractiveData (class IDHtml, DataUI, IDSurface)
import InteractiveData as ID
import VirtualDOM (class Html)

type Sample =
  { firstName :: String
  , lastName :: String
  }

sampleDataUi
  :: forall html
   . IDHtml html
  => DataUI (IDSurface html) _ _ _ _ Sample
sampleDataUi =
  ID.record_
    { firstName: ID.string_
    , lastName: ID.string_
    }

itf :: forall html. Html html => ID.DataUiItf html _ _ Sample
itf =
  ID.runApp
    { name: "Sample" }
    sampleDataUi