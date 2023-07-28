module Demo.Samples.MinimalComplete where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData.DataUIs as ID
import InteractiveData.Run as ID.Run
import VirtualDOM.Impl.Halogen as HI

main :: Effect Unit
main = do
  let
    -- Compose a Data UI for a specific type
    sampleDataUi = ID.string_
  let
    { ui, extract } =
      sampleDataUi
        # ID.Run.toUI
            { name: "Sample"
            , initData: Just "hello!"
            , context: ID.Run.ctxNoWrap
            }

  ui
    -- Turn into a Halogen component
    # HI.uiToHalogenComponent
        { onStateChange: \newState -> do
            log (show $ extract newState)
        }
    -- Mount at the root element
    # HI.uiMountAtId "root"
