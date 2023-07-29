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
    -- Compose a Data UI for a specific type
    sampleDataUi = ID.string_
  let
    itf =
      sampleDataUi
        # ID.runApp
            { name: "Sample"
            }

    ui = ID.getUi Nothing itf
    extract = ID.getExtract itf
  ui
    -- Turn into a Halogen component
    # HI.uiToHalogenComponent
        { onStateChange: \newState -> do
            log (show $ extract newState)
        }
    -- Mount at the root element
    # HI.uiMountAtId "root"
