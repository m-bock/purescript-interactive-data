module Demo.RunReact
  ( runReact
  )
  where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData.Entry (InteractiveDataApp)
import Chameleon.Impl.ReactBasic (ReactHtml)
import Chameleon.Impl.ReactBasic as ReactImpl

runReact
  :: forall msg sta a
   . Show a
  => InteractiveDataApp ReactHtml msg sta a
  -> Effect Unit
runReact app = do
  let
    { ui, extract } = app
  ui
    # ReactImpl.uiToReactComponent
        { onStateChange: \newState -> do
            log (show $ extract newState)
        }
    # ReactImpl.mountAtId "root"