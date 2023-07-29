module Demo.Samples.Unwrapped where

import Data.Identity (Identity)
import Data.Maybe (Maybe(..))
import DataMVC.Types (DataUI, DataResult)
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs (StringMsg, StringState)
import InteractiveData.DataUIs as ID
import InteractiveData.Run as Run
import MVC.Types (UI)
import VirtualDOM (class Html)

type Sample = String

sampleDataUi
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs StringMsg
       StringState
       String
sampleDataUi = ID.string_

ui
  :: forall html
   . Html html
  => { ui ::
         UI html
           (Identity StringMsg)
           (Identity StringState)
     , extract ::
         Identity StringState
         -> DataResult Sample
     }
ui = Run.toUI
  { name: "Sample"
  , initData: Nothing
  , context: Run.ctxNoWrap
  }
  sampleDataUi