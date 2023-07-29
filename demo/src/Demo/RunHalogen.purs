module Demo.RunHalogen where

import Prelude

import DataMVC.Types (DataResult)
import Effect (Effect)
import Effect.Class.Console (log)
import MVC.Types (UI)
import VirtualDOM.Impl.Halogen (HalogenHtml)
import VirtualDOM.Impl.Halogen as HI

runHalogen
  :: forall msg sta a
   . Show a => Show sta
  => { ui :: UI HalogenHtml msg sta
     , extract :: sta -> DataResult a
     }
  -> Effect Unit
runHalogen { ui, extract } = do
  ui
    # HI.uiToHalogenComponent
        { onStateChange: \newState -> do
            log (show $ extract newState)
        }
    # HI.uiMountAtId "root"