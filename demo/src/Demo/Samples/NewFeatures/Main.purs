module Demo.Samples.NewFeatures.Main
  ( main
  )
  where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData as ID
import Chameleon.Impl.Halogen as HI

main :: Effect Unit
main = do
  let
    sampleDataUi =
      ID.record_
        { field1: ID.record_
            { field11: ID.record_
                { field111: ID.string_
                }
            }
        , field2: ID.record_
            { field22: ID.record_
                { field222: ID.string_
                }
            }
        , field3: ID.record_
            { field33: ID.record_
                { field333: ID.string_
                }
            , field4: ID.record_
                { field44: ID.record_
                    { field444: ID.string_
                    }
                }
            }
        }

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
