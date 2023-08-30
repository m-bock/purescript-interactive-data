module Landing.Main where

import Prelude

import Chameleon.Impl.Halogen (runHalogenHtml)
import Chameleon.Impl.Halogen as HI
import Chameleon.Styled (runStyleT)
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen as H
import Halogen as Halogen
import Landing.App as UIApp

app
  :: forall q i o
   . Halogen.Component q i o Aff
app =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval
    }
  where
  initialState _ = unit

  render _ =
    runHalogenHtml $ runStyleT $ UIApp.view

main :: Effect Unit
main = do
  HI.uiMountAtId "root" app
