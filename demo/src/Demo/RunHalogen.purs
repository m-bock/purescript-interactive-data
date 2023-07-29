module Demo.RunHalogen where

import Prelude

import DataMVC.Types (DataResult, DataUiItf)
import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData.Run as Run
import MVC.Types (UI)
import VirtualDOM.Impl.Halogen (HalogenHtml)
import VirtualDOM.Impl.Halogen as HI

runHalogen
  :: forall msg sta a
   . Show a
  => DataUiItf HalogenHtml msg sta a
  -> Effect Unit
runHalogen itf = do
  let
    ui = Run.getUi itf
    extract = Run.getExtract itf
  ui
    # HI.uiToHalogenComponent
        { onStateChange: \newState -> do
            log (show $ extract newState)
        }
    # HI.uiMountAtId "root"