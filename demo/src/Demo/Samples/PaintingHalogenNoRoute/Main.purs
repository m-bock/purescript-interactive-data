module Demo.Samples.PaintingHalogenNoRoute.Main
  ( main
  ) where

import Prelude

import Chameleon.Impl.Halogen (HalogenHtml)
import Chameleon.Impl.Halogen as ChameleonHalogen
import Chameleon.Styled (StyleT, runStyleT)
import Demo.Common.Embedded as UIEmbedded
import Demo.Common.PaintingSample (Painting)
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen as H
import Halogen as Halogen
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import InteractiveData (DataResult)

mkHalogenComponent
  :: forall q i o
   . Halogen.Component q i o Aff
mkHalogenComponent =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval
        { handleAction = handleAction
        }
    }

  where
  { ui, extract } = UIEmbedded.sampleApp

  initialState _ = ui.init

  render state =
    let
      dataResult :: DataResult Painting
      dataResult = extract state

      html :: StyleT HalogenHtml _
      html = UIEmbedded.view
        { viewInteractiveData: ui.view state
        }
        dataResult
    in
      ChameleonHalogen.runHalogenHtml $ runStyleT html

  handleAction msg = do
    H.modify_ $ ui.update msg

main :: Effect Unit
main = do
  let
    halogenComponent = mkHalogenComponent

  HA.runHalogenAff do
    body <- HA.awaitBody
    _ <- runUI halogenComponent unit body
    pure unit
