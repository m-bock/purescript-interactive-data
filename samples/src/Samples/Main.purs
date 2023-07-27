module Samples.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

type EnvVars =
  { "FRAMEWORK" :: String
  , "SAMPLE" :: String
  }

data Framework
  = Halogen
  | React

data Sample =
  Unwrapped

main :: EnvVars -> Effect Unit
main envVars = do
  log "hello world"