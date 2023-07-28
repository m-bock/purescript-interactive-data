module Demo.Samples.MinimalComplete where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData.DataUIs as ID
import InteractiveData.Run as VD.Run
import VirtualDOM.Impl.Halogen as HI

main :: Effect Unit
main = do
  let
    sampleDataUi = ID.string_
  let
    { ui, extract } =
      sampleDataUi
        # VD.Run.toUI
            { name: "Sample"
            , initData: Just "hello!"
            , context: VD.Run.ctxNoWrap
            }

  ui
    # HI.uiToHalogenComponent
        { onStateChange: \newState -> do
            log (show $ extract newState)
        }
    # HI.uiMountAtId "root"