{-
<!-- START hide -->
-}
module Manual.RunningDataUIs.Halogen where

{-
<!-- END hide -->

# Running Data UIs with Halogen

<!-- START imports -->
-}

import Prelude

import Chameleon (class Html)
import Chameleon.Impl.Halogen (runHalogenHtml)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class.Console (logShow)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HE
import Halogen.VDom.Driver as HD
import InteractiveData (InteractiveDataApp)
import InteractiveData as ID

{-
<!-- END imports -->

This chapter describes how to run a Data UI with Halogen.
The code example is self-contained.

## Create an `InteractiveDataApp`
Refer to the previous chapters for details about this step.
-}

type MyType =
  { firstName :: String
  , lastName :: String
  }

myApp
  :: forall html
   . Html html
  => InteractiveDataApp html _ _ MyType
myApp = ID.toApp
  { name: "My App" }
  ( ID.record_
      { firstName: ID.string_
      , lastName: ID.string_
      }
  )

{-
## Create a Halogen component

We use the `myApp` value that we created above inside a simple Halogen component.
-}

myHalogenComponent
  :: forall q i o
   . H.Component q i o Aff
myHalogenComponent =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval
        { handleAction = handleAction }
    }
  where
  { ui, extract } = myApp
  -- ^ Unwrap some useful values

  initialState _ = ui.init

  render state =
    HE.div_
      [ runHalogenHtml $ ui.view state
      -- ^ Embed interactive-data
      --   control panel

      , HE.text (show $ extract state)
      -- ^ Some other Halogen HTML
      --   Shows current data
      ]

  handleAction msg = do
    H.modify_ $ ui.update msg

    state <- H.get
    logShow $ extract state
    -- ^ On every action,
    --   log the current state

    pure unit

{-
## Mount the component to the DOM

This step should be familiar to you if you have used Halogen before.
-}

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    _ <- HD.runUI myHalogenComponent unit body
    pure unit
