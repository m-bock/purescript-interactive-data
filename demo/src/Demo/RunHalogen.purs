module Demo.RunHalogen where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData.Entry (InteractiveDataApp)
import VirtualDOM.Impl.Halogen (HalogenHtml)
import VirtualDOM.Impl.Halogen as HI

runHalogen
  :: forall msg sta a
   . Show a
  => InteractiveDataApp HalogenHtml msg sta a
  -> Effect Unit
runHalogen app = do
  let
    { ui, extract } = app
  ui
    # HI.uiToHalogenComponent
        { onStateChange: \newState -> do
            log (show $ extract newState)
        }
    # HI.uiMountAtId "root"