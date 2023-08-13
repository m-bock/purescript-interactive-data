module Demo.Samples.HalogenFullscreen.Main
  ( main
  ) where

import Prelude

import Chameleon.Impl.Halogen as HI
import Chameleon.Impl.Halogen.Mount.Routed as HI.Routed
import Data.Maybe (Maybe(..))
import Demo.Common.CompleteSample (sampleDataUi)
import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData as ID
import InteractiveData.App.Routing as ID.Routing

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

  routeIO <- ID.Routing.getRouteIO

  let
    halogenComponent =
      HI.Routed.mkRoutableComponent
        { routeIO
        , routeSpec: ID.Routing.routeSpec
        , onStateChange: \_ newState -> do

            log (show $ sampleApp.extract newState)
        }
        sampleApp.ui

  HI.uiMountAtId "root" halogenComponent
