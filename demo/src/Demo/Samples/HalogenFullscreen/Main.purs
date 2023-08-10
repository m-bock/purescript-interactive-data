module Demo.Samples.HalogenFullscreen.Main
  ( main
  )
  where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData as ID
import Chameleon.Impl.Halogen as HI
import Demo.Common.CompleteSample (sampleDataUi)

main :: Effect Unit
main = do
  let

    sampleApp =
      ID.toApp
        { name: "Sample"
        , initData: Nothing
        , fullscreen: true
        }
        sampleDataUi

    halogenComponent =
      HI.uiToHalogenComponent
        { onStateChange: \newState -> do

            log (show $ sampleApp.extract newState)
        }
        sampleApp.ui

  HI.uiMountAtId "root" halogenComponent
