module Demo.RunHalogen
  ( runHalogen
  ) where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData.Entry (InteractiveDataApp)
import Chameleon.Impl.Halogen (HalogenHtml)
import Chameleon.Impl.Halogen as HalogenImpl

runHalogen
  :: forall msg sta a
   . Show a
  => InteractiveDataApp HalogenHtml msg sta a
  -> Effect Unit
runHalogen app = do
  let
    { ui, extract } = app
  ui
    # HalogenImpl.uiToHalogenComponent
        { onStateChange: \newState -> do
            log (show $ extract newState)
        }
    # HalogenImpl.uiMountAtId "root"