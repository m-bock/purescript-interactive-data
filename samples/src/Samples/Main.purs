module Samples.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)
import Foreign.Object (Object)
import Samples.EnvVars (EnvVars, Sample(..), getEnvVars)
import Samples.RunHalogen (runHalogen)
import Samples.Unwrapped as Samples.Unwrapped

main :: Object String -> Effect Unit
main envVarsObj = do
  envVars :: EnvVars <- getEnvVars envVarsObj

  case envVars."SAMPLE" of
    Unwrapped -> do
      log "Running unwrapped sample"
      let ui = Samples.Unwrapped.ui
      runHalogen ui
