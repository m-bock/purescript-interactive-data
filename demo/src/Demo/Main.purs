module Demo.Main where

import Prelude

import Demo.EnvVars (EnvVars, Sample(..), getEnvVars)
import Demo.RunHalogen (runHalogen)
import Demo.Samples.Basic as Samples.Basic
import Demo.Samples.Unwrapped as Samples.Unwrapped
import Effect (Effect)
import Effect.Class.Console (log)
import Foreign.Object (Object)

main :: Object String -> Effect Unit
main envVarsObj = do
  envVars :: EnvVars <- getEnvVars envVarsObj

  case envVars."SAMPLE" of
    Unwrapped -> do
      log "Running 'Unwrapped' sample"
      let ui = Samples.Unwrapped.ui
      runHalogen ui
    Basic -> do
      pure unit
      -- log "Running 'Basic' sample"
      -- let ui = Samples.Basic.ui
      -- runHalogen ui
    
