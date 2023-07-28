module Demo.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)
import Foreign.Object (Object)
import Demo.EnvVars (EnvVars, Sample(..), getEnvVars)
import Demo.RunHalogen (runHalogen)
import Demo.Samples.Unwrapped as Samples.Unwrapped

main :: Object String -> Effect Unit
main envVarsObj = do
  envVars :: EnvVars <- getEnvVars envVarsObj

  case envVars."SAMPLE" of
    Unwrapped -> do
      log "Running unwrapped sample"
      let ui = Samples.Unwrapped.ui
      runHalogen ui
