module Demo.Samples.EmbedReact where

import Prelude

import Data.Argonaut (encodeJson, stringifyWithIndent)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import DataMVC.Types (DataUI, DataUiItf(..))
import Effect (Effect)
import Effect.Console (log)
import InteractiveData.App.WrapApp (wrapApp)
import InteractiveData.App.WrapData as App.WrapData
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.DataUIs as ID
import InteractiveData.Run as Run
import React.Basic.DOM (css)
import React.Basic.DOM as DOM
import React.Basic.Hooks ((/\))
import React.Basic.Hooks as React
import VirtualDOM.Impl.ReactBasic as RI
import VirtualDOM.Impl.ReactBasic.Html (ReactHtml, defaultConfig, runReactHtml)

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

sampleItf :: DataUiItf ReactHtml _ _ Sample
sampleItf =
  Run.run
    { name: "Sample"
    , initData: Nothing
    , context: App.WrapData.dataUiCtx
    }
    $ wrapApp sampleDataUi

reactComponent :: React.Component {}
reactComponent = do
  let
    DataUiItf itf = sampleItf
  React.component "Root" \_props -> React.do

    state /\ setState <- React.useState $ itf.init Nothing

    let
      handler msg = do
        setState $ itf.update msg

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
                { style: css { border: "1px solid black", height: "50%", flex: "1 1 0px" }
                , children:
                    [ case itf.extract state of
                        Left errors -> DOM.text $ show errors
                        Right value ->
                          DOM.pre_
                            [ DOM.text $ stringifyWithIndent 2 $ encodeJson value
                            ]
                    ]
                }

            , DOM.div
                { style: css { border: "1px solid black", height: "50%", flex: "1 1 0px" }
                , children:
                    [ runReactHtml { handler } defaultConfig
                        $ itf.view state
                    ]
                }

            ]
        }

main :: Effect Unit
main = RI.mountAtId "root" reactComponent