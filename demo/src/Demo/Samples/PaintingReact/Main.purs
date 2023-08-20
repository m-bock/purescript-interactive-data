module Demo.Samples.PaintingReact.Main
  ( main
  ) where

import Prelude

import Chameleon.Impl.ReactBasic as RI
import Chameleon.Impl.ReactBasic.Html (defaultConfig)
import Chameleon.Styled (runStyleT)
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

      reactRender :: DataResult Painting -> JSX
      reactRender result =
        UIEmbedded.view
          { viewInteractiveData: ui.view state
          }
          result
          # runStyleT
          # RI.runReactHtml { handler } defaultConfig

    pure $ reactRender dataResult

main :: Effect Unit
main = RI.mountAtId "root" reactComponent
