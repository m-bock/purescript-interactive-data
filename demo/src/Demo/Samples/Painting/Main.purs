module Demo.Samples.Painting.Main
  ( main
  ) where

import Prelude

import Chameleon.Impl.ReactBasic as RI
import Chameleon.Impl.ReactBasic.Html (ReactHtml, defaultConfig)
import Chameleon.Styled (StyleT, runStyleT)
import Demo.Common.Embedded as UIEmbedded
import Demo.Common.PaintingSample (Painting)
import Effect (Effect)
import InteractiveData (DataResult)
import React.Basic.Hooks (JSX, (/\))
import React.Basic.Hooks as React

reactComponent :: React.Component {}
reactComponent = do
  let
    { ui, extract } = UIEmbedded.sampleApp

  React.component "Root" \_props -> React.do

    state /\ setState <- React.useState $ ui.init

    let
      handler msg = do
        setState $ ui.update msg

      dataResult :: DataResult Painting
      dataResult = extract state

      reactHtml :: StyleT ReactHtml _
      reactHtml = UIEmbedded.view
        { viewInteractiveData: ui.view state
        }
        dataResult

      jsx :: JSX
      jsx = RI.runReactHtml { handler } defaultConfig $ runStyleT reactHtml

    pure jsx

---

main :: Effect Unit
main = RI.mountAtId "root" reactComponent
