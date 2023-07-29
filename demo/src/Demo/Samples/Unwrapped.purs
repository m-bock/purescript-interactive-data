module Demo.Samples.Unwrapped where

import Prelude

import Data.Identity (Identity)
import Data.Maybe (Maybe(..))
import Data.These (These)
import DataMVC.Types (DataUI, DataResult)
import InteractiveData.Core (class IDHtml, IDOutMsg, IDSurface(..))
import InteractiveData.Core as Core
import InteractiveData.DataUIs as ID
import InteractiveData.Run as Run
import MVC.Types (UI)
import VirtualDOM (class Html, class MaybeMsg)

type Sample = String

sampleDataUi
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs _ _ String
sampleDataUi = ID.string_

ui
  :: forall html
   . Html html
  => MaybeMsg html
  => { ui :: UI html (Identity _) (Identity _)
     , extract :: Identity _ -> DataResult Sample
     }
ui = Run.toUI
  { name: "Sample"
  , initData: Nothing
  , context: Run.ctxNoWrap
  }
  sampleDataUi