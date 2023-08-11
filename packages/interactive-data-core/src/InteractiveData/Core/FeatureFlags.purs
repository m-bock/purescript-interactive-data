module InteractiveData.Core.FeatureFlags
  ( featureFlags
  ) where

import Prelude

import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Data.Maybe (Maybe)
import Foreign.Object (Object)
import Type.Proxy (Proxy(..))
import TypedEnv (printEnvError)
import TypedEnv as TypedEnv

foreign import envVars :: Object String

type FeatureFlags :: forall k. k -> Type
type FeatureFlags f =
  {}

def :: FeatureFlags It
def =
  {}

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
      Right _ ->
        {}
