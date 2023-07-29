module Demo.Samples.Basic where

import Prelude

import Data.Identity (Identity)
import Data.Maybe (Maybe(..))
import DataMVC.Types (DataResult, DataUI, DataUiItf)
import InteractiveData.App.WrapApp (wrapApp)
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.App.WrapData as App.WrapData
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs (StringMsg, StringState)
import InteractiveData.DataUIs as ID
import InteractiveData.Run as Run
import MVC.Types (UI)
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

itf :: forall html. Html html => DataUiItf html _ _ Sample
itf =
  Run.run
    { name: "Sample"
    , context: App.WrapData.dataUiCtx
    }
    $ wrapApp sampleDataUi