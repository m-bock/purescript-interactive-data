module InteractiveData.Entry
  ( runApp
  )
  where

import Prelude

import DataMVC.Types (DataUI, DataUiItf)
import InteractiveData.App (AppMsg, AppState)
import InteractiveData.App as App
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.App.WrapData as App.WrapData
import InteractiveData.Core (IDSurface)
import InteractiveData.Run as Run
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import VirtualDOM (class Html)

runApp
  :: forall html msg sta a
   . Html html
  => { name :: String
     }
  -> DataUI (IDSurface (IDHtmlT html)) WrapMsg WrapState msg sta a
  -> DataUiItf html (AppMsg (WrapMsg msg)) (AppState (WrapState sta)) a
runApp { name } dataUi =
  Run.run
    { name
    , context: App.WrapData.dataUiCtx
    }
    $ App.wrapApp dataUi