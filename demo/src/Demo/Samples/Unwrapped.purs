module Demo.Samples.Unwrapped where

import Chameleon (class Html)
import DataMVC.Types (DataUI, DataUiInterface)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs (StringMsg, StringState)
import InteractiveData.DataUIs as ID
import InteractiveData.Run as Run

type Sample = String

sampleDataUi
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs StringMsg
       StringState
       String
sampleDataUi = ID.string_

itf :: forall html. Html html => DataUiInterface html StringMsg StringState String
itf = Run.run
  { name: "Sample"
  , context: Run.ctxNoWrap
  , fullscreen: true
  }
  sampleDataUi