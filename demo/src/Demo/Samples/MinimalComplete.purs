module Demo.Samples.MinimalComplete where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData as ID
import VirtualDOM.Impl.Halogen as HI

main :: Effect Unit
main = do
  let
    -- Compose a "Data UI" for a specific type
    sampleDataUi =
      ID.record_
        { firstName: ID.string_
        , lastName: ID.string_
        }

    -- Turn "Data UI" into
    sampleApp =
      ID.toApp
        { name: "Sample"
        , initData : Nothing
        }
        sampleDataUi

    -- Create Halogen component
    halogenComponent =
      HI.uiToHalogenComponent
        { onStateChange: \newState -> do
            
            -- Use the `extract` function to get data out of the state
            log (show $ sampleApp.extract newState)
        }
        sampleApp.ui

  -- Finally mount the component at the root element
  HI.uiMountAtId "root" halogenComponent
