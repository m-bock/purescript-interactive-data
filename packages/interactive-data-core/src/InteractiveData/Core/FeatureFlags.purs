module InteractiveData.Core.FeatureFlags
  ( featureFlags
  )
  where

import Prelude

import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Data.Maybe (Maybe, fromMaybe)
import Foreign.Object (Object)
import Type.Proxy (Proxy(..))
import TypedEnv (printEnvError)
import TypedEnv as TypedEnv

foreign import envVars :: Object String

type FeatureFlags f =
  { "NEW_DATA_WRAP" :: f Boolean
  }

def :: FeatureFlags It
def =
  { "NEW_DATA_WRAP": false
  }

type It :: forall k. k -> k
type It a = a

featureFlags :: FeatureFlags It
featureFlags =
  let
    parsed :: Either String (FeatureFlags Maybe)
    parsed =
      TypedEnv.fromEnv Proxy envVars
        # lmap printEnvError
  in
    case parsed of
      Left _ -> def
      Right result ->
        { "NEW_DATA_WRAP": fromMaybe def."NEW_DATA_WRAP" result."NEW_DATA_WRAP"
        }
