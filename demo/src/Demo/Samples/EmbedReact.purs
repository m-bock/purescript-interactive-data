module Demo.Samples.EmbedReact where

import Prelude

import Data.Argonaut (encodeJson, stringifyWithIndent)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import InteractiveData (DataUI)
import InteractiveData as ID
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.Entry (InteractiveDataApp)
import React.Basic.DOM (css)
import React.Basic.DOM as DOM
import React.Basic.Hooks ((/\))
import React.Basic.Hooks as React
import Chameleon.Impl.ReactBasic as RI
import Chameleon.Impl.ReactBasic.Html (ReactHtml, defaultConfig, runReactHtml)

type Sample =
  { firstName :: String
  , lastName :: String
  }

sampleDataUi
  :: forall html
   . IDHtml html
  => DataUI (IDSurface html) _ _ _ _ Sample
sampleDataUi =
  ID.record_
    { firstName: ID.string_
    , lastName: ID.string_
    }

sampleApp :: InteractiveDataApp ReactHtml _ _ Sample
sampleApp =
  ID.toApp
    { name: "Sample"
    , initData: Nothing
    , fullscreen: false
    }
    sampleDataUi

reactComponent :: React.Component {}
reactComponent = do
  let
    { ui, extract } = sampleApp

  React.component "Root" \_props -> React.do

    state /\ setState <- React.useState $ ui.init

    let
      handler msg = do
        setState $ ui.update msg

    pure $
      DOM.div
        { style: css
            { position: "fixed"
            , top: "0"
            , left: "0"
            , right: "0"
            , bottom: "0"
            , display: "flex"
            , flexDirection: "column"
            , gap: "50px"
            , padding: "50px"
            }
        , children:
            [ DOM.div
                { style: css
                    { border: "1px solid black"
                    , height: "50%"
                    , flex: "1 1 0px"
                    }
                , children:
                    [ case extract state of
                        Left errors -> DOM.text $ show errors
                        Right value ->
                          DOM.pre_
                            [ DOM.text $ stringifyWithIndent 2 $ encodeJson value
                            ]
                    ]
                }

            , DOM.div
                { style: css
                    { border: "1px solid black"
                    , height: "50%"
                    , flex: "1 1 0px"
                    }
                , children:
                    [ runReactHtml { handler } defaultConfig
                        $ ui.view state
                    ]
                }

            ]
        }

main :: Effect Unit
main = RI.mountAtId "root" reactComponent