module Demo.Main where

import Prelude

import Demo.EnvVars (EnvVars, Sample(..), getEnvVars)
import Demo.RunHalogen (runHalogen)
import Demo.RunReact (runReact)
import Demo.Samples.EmbedReact as Samples.EmbedReact
import Demo.Samples.Simple as Samples.Simple
import Effect (Effect)
import Effect.Class.Console (log)
import Foreign.Object (Object)

main :: Object String -> Effect Unit
main envVarsObj = do
  envVars :: EnvVars <- getEnvVars envVarsObj

  let
    sample :: Sample
    sample = envVars."SAMPLE"

  log ("Running '" <> show sample <> "' sample")

  case sample of
    SimpleHalogen -> do
      let sampleApp = Samples.Simple.sampleApp
      runHalogen sampleApp

    SimpleReact -> do
      let sampleApp = Samples.Simple.sampleApp
      runReact sampleApp

    EmbedReact -> do
      Samples.EmbedReact.main
