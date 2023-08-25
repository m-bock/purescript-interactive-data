module Demo.Samples.DocsEmbed.Main
  ( embedKeys
  , main
  ) where

import Prelude

import Chameleon as C
import Chameleon.Impl.Halogen (HalogenHtml, runHalogenHtml)
import Chameleon.Impl.Halogen as HI
import Chameleon.Styled (class HtmlStyled, StyleT, runStyleT, styleNode)
import Data.Array as Array
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), Replacement(..))
import Data.String as Str
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class.Console (error)
import Halogen as H
import Halogen as Halogen
import InteractiveData (AppMsg, AppState, DataUI, WrapMsg, WrapState)
import InteractiveData as ID
import InteractiveData.Entry (InteractiveDataApp)
import Manual.ComposingDataUIs.Primitives as Primitives
import Manual.ComposingDataUIs.Records as Records

foreign import getQueryString :: Effect String

embeds :: Map String (Effect Unit)
embeds =
  Map.fromFoldable
    [ "int" /\ app { showMenuOnStart: false } Primitives.demoInt
    , "string" /\ app { showMenuOnStart: false } Primitives.demoString
    , "boolean" /\ app { showMenuOnStart: false } ID.boolean_
    , "number" /\ app { showMenuOnStart: false } ID.number_
    , "record" /\ app { showMenuOnStart: true } Records.demoRecord
    ]

embedKeys :: Array String
embedKeys = Array.fromFoldable $ Map.keys embeds

viewWrapper :: forall html msg. HtmlStyled html => { atDataStr :: String, atInteractiveData :: html msg } -> html msg
viewWrapper { atInteractiveData, atDataStr } =
  let
    el =
      { root: styleNode C.div
          [ "display: grid"
          , "grid-template-rows: 5fr auto"
          , "height: 100%"
          , "background: hsl(200, 7%, 8%);"
          , "padding: 10px"
          , "box-sizing: border-box"
          , "position: fixed"
          , "top: 0"
          , "left: 0"
          , "right: 0"
          , "bottom: 0"
          ]
      , atInteractiveData: styleNode C.div
          [ "border:1px solid #9f9f9f"
          , "border-radius: 5px"
          , "margin-top: 10px"
          , "margin-bottom: 10px"
          ]
      , atDataStr: styleNode C.pre
          [ "font-size: 10px"
          , "color: #c3c3c3"
          , "padding: 0 10px"
          ]
      }
  in
    el.root []
      [ el.atInteractiveData []
          [ atInteractiveData ]
      , el.atDataStr []
          [ C.text atDataStr ]
      ]

mkHalogenComponent
  :: forall q i o msg sta a
   . Show a
  => InteractiveDataApp (StyleT HalogenHtml) (AppMsg (WrapMsg msg)) (AppState (WrapState sta)) a
  -> Halogen.Component q i o Aff
mkHalogenComponent { ui, extract } =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }
  where
  initialState _ = ui.init

  render state =
    runHalogenHtml $ runStyleT $ viewWrapper
      { atInteractiveData: ui.view state
      , atDataStr: show $ extract state
      }

  handleAction msg = do
    H.modify_ $ ui.update msg

app :: forall a. Show a => { showMenuOnStart :: Boolean } -> DataUI _ _ _ _ _ a -> Effect Unit
app { showMenuOnStart } dataUi = do
  let
    sampleApp =
      ID.toApp
        { name: ""
        , initData: Nothing
        , fullscreen: false
        , showLogo: false
        , showMenuOnStart
        }
        dataUi

  HI.uiMountAtId "root" $ mkHalogenComponent sampleApp

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
