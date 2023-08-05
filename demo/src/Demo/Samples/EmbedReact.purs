module Demo.Samples.EmbedReact where

import Prelude

import Chameleon.Impl.ReactBasic as RI
import Chameleon.Impl.ReactBasic.Html (ReactHtml, defaultConfig, runReactHtml)
import Data.Argonaut (encodeJson, stringifyWithIndent)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import InteractiveData (DataUI)
import InteractiveData as ID
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.Entry (InteractiveDataApp)
import React.Basic.DOM (CSS, css)
import React.Basic.DOM as DOM
import React.Basic.Hooks ((/\))
import React.Basic.Hooks as React

type Sample =
  { user ::
      { firstName :: String
      , lastName :: String
      , size :: Number
      }
  , meta ::
      { description :: String
      , headline :: String
      }
  }

sampleDataUi
  :: forall html
   . IDHtml html
  => DataUI (IDSurface html) _ _ _ _ Sample
sampleDataUi = ID.record_
  { user: ID.record_
      { firstName: ID.string_
      , lastName: ID.string_
      , size: ID.number { min: 0.0, max: 100.0 }
      }
  , meta: ID.record_
      { description: ID.string_
      , headline: ID.string_
      }
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
        { style: styles.root
        , children:
            [ DOM.div
                { style: styles.jsonBox
                , children:
                    [ DOM.h3
                        { style: styles.jsonBoxHeader
                        , children: [ DOM.text "JSON encoded data:" ]
                        }
                    , case extract state of
                        Left errors -> DOM.text $ show errors
                        Right value ->
                          DOM.pre
                            { style: css { margin: "0px" }
                            , children:
                                [ DOM.text $ stringifyWithIndent 2 $ encodeJson value
                                ]
                            }
                    ]
                }

            , DOM.div
                { style: styles.embedBox
                , children:
                    [ runReactHtml { handler } defaultConfig
                        $ ui.view state
                    ]
                }
            ]
        }

main :: Effect Unit
main = RI.mountAtId "root" reactComponent

--------------------------------------------------------------------------------
--- Styles
--------------------------------------------------------------------------------

styles
  :: { embedBox :: CSS
     , jsonBox :: CSS
     , jsonBoxHeader :: CSS
     , root :: CSS
     }
styles =
  { root: css
      { position: "fixed"
      , top: "0"
      , left: "0"
      , right: "0"
      , bottom: "0"
      , display: "flex"
      , flexDirection: "column"
      , gap: "50px"
      , padding: "50px"
      , boxSizing: "border-box"
      , overflow: "auto"
      , backgroundColor: "#3375af"
      }
  , jsonBox: css
      { backgroundColor: "rgb(241 241 241)"
      , maxHeight: "200px"
      , maxWidth: "900px"
      , flexGrow: "0"
      , flexShrink: "0"
      , boxSizing: "border-box"
      , overflow: "auto"
      }
  , jsonBoxHeader: css
      { position: "sticky"
      , top: "0"
      , margin: "0"
      , backgroundColor: "rgb(241 241 241)"
      , borderBottom: "1px solid #ccc"
      , padding: "5px"
      }
  , embedBox: css
      { maxHeight: "500px"
      , height: "500px"
      , maxWidth: "900px"
      , flexGrow: "0"
      , flexShrink: "0"
      , boxSizing: "border-box"
      , padding: "3px"
      }
  }
