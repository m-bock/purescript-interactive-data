module Demo.Samples.DocsEmbed.Main
  ( embedKeys
  , main
  ) where

import Prelude

import Chameleon.Impl.Halogen as HI
import Data.Array as Array
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), Replacement(..))
import Data.String as Str
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class.Console (error)
import InteractiveData (DataUI)
import InteractiveData as ID
import Manual.ComposingDataUIs.Primitives as Primitives
import Manual.ComposingDataUIs.Records as Records


foreign import getQueryString :: Effect String

embeds :: Map String (Effect Unit)
embeds =
  Map.fromFoldable
    [ "int" /\ app Primitives.demoInt
    , "string" /\ app Primitives.demoString
    , "boolean" /\ app ID.boolean_
    , "number" /\ app ID.number_
    , "record" /\ app Records.demoRecord
    ]

embedKeys :: Array String
embedKeys = Array.fromFoldable $ Map.keys embeds

app :: forall a. DataUI _ _ _ _ _ a -> Effect Unit
app dataUi = do
  let
    sampleApp =
      ID.toApp
        { name: "Sample"
        , initData: Nothing
        , fullscreen: true
        , showLogo: false
        }
        dataUi

    halogenComponent =
      HI.uiToHalogenComponent
        { onStateChange: \_ -> pure unit
        }
        sampleApp.ui

  HI.uiMountAtId "root" halogenComponent

main :: Effect Unit
main = do
  queryString <- getQueryString
  let
    embedId = Str.replace (Pattern "?") (Replacement "") queryString

    maybeRunEmbed = Map.lookup embedId embeds

  case maybeRunEmbed of
    Just runEmbed -> runEmbed
    Nothing -> do
      error "Invalid query string"
      pure unit
