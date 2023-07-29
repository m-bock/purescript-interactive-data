module Demo.Samples.Basic where

import Data.Identity (Identity)
import Data.Maybe (Maybe(..))
import DataMVC.Types (DataUI, DataResult)
import InteractiveData.App.WrapData as App.WrapData
import InteractiveData.Core (class IDHtml, IDSurface, WrapMsg, WrapState)
import InteractiveData.DataUIs (StringMsg, StringState)
import InteractiveData.DataUIs as ID
import InteractiveData.Run as Run
import MVC.Types (UI)
import VirtualDOM (class Html, class MaybeMsg)

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
  => MaybeMsg html
  => { ui ::
         UI html
           (WrapMsg StringMsg)
           (WrapState StringState)
     , extract ::
         WrapState StringState
         -> DataResult Sample
     }
ui = Run.toUI
  { name: "Sample"
  , initData: Nothing
  , context: App.WrapData.dataUiCtx
  }
  sampleDataUi