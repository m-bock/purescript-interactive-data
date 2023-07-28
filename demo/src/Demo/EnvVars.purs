module Demo.EnvVars
  ( EnvVars
  , Framework(..)
  , Sample(..)
  , getEnvVars
  ) where

import Prelude

import Data.Either (Either(..))
import Data.List (List)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Foreign.Object (Object)
import Type.Proxy (Proxy(..))
import TypedEnv (class ParseValue, EnvError, fromEnv, printEnvError)

type EnvVars =
  { "FRAMEWORK" :: Framework
  , "SAMPLE" :: Sample
  }

data Framework
  = Halogen
  | React

instance ParseValue Framework where
  parseValue = case _ of
    "halogen" -> Just Halogen
    "react" -> Just React
    _ -> Nothing

instance ParseValue Sample where
  parseValue = case _ of
    "unwrapped" -> Just Unwrapped
    _ -> Nothing

data Sample =
  Unwrapped

getEnvVars :: Object String -> Effect EnvVars
getEnvVars envVarsObj =
  let
    result :: Either (List EnvError) EnvVars
    result = fromEnv Proxy envVarsObj
  in
    case result of
      Left errors -> do
        throw ("Error parsing environment variables:" <> printEnvError errors)
      Right x -> pure x

