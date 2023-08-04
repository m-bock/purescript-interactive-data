module Demo.EnvVars
  ( EnvVars
  , Sample(..)
  , getEnvVars
  , sampleValues
  ) where

import Prelude

import Data.Bounded.Generic (genericBottom, genericTop)
import Data.Either (Either(..))
import Data.Enum (class Enum, enumFromTo)
import Data.Enum.Generic (genericPred, genericSucc)
import Data.Generic.Rep (class Generic)
import Data.List (List)
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe)
import Data.Set as Set
import Data.Show.Generic (genericShow)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Effect.Exception (throw)
import Foreign.Object (Object)
import Type.Proxy (Proxy(..))
import TypedEnv (class ParseValue, EnvError, fromEnv, printEnvError)

type EnvVars =
  { "SAMPLE" :: Sample
  }

instance ParseValue Sample where
  parseValue :: String -> Maybe Sample
  parseValue str = Map.lookup str sampleLookup

data Sample
  = SimpleHalogen
  | SimpleReact
  | EmbedReact

derive instance Generic Sample _

instance Enum Sample where
  succ = genericSucc
  pred = genericPred

instance Bounded Sample where
  top = genericTop
  bottom = genericBottom

derive instance Ord Sample
derive instance Eq Sample
instance Show Sample where
  show = genericShow

sampleLookup :: Map String Sample
sampleLookup =
  let
    cases :: Array Sample
    cases = enumFromTo bottom top

    caseLookup :: Array (String /\ Sample)
    caseLookup = map (\x -> show x /\ x) cases

  in
    Map.fromFoldable caseLookup

sampleValues :: Array String
sampleValues = Set.toUnfoldable $ Map.keys sampleLookup

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
