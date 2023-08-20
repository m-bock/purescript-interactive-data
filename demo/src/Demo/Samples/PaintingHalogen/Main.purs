module Demo.Samples.PaintingHalogen.Main
  ( main
  ) where

import Prelude

import Chameleon.Impl.Halogen (HalogenHtml)
import Chameleon.Impl.Halogen as ChameleonHalogen
import Chameleon.Styled (StyleT, runStyleT)
import Data.Maybe (Maybe(..))
import Data.These (These(..))
import Demo.Common.Embedded as UIEmbedded
import Demo.Common.PaintingSample (Painting)
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen (get, liftEffect, subscribe)
import Halogen as H
import Halogen as Halogen
import Halogen.Aff as HA
import Halogen.Subscription (makeEmitter)
import Halogen.VDom.Driver (runUI)
import InteractiveData (DataResult)
import InteractiveData.App.Routing (RouteIO, Route, routeSpec)
import InteractiveData.App.Routing as ID.Routing

data Msg route msg = Init | ChildMsg msg | MsgNewRoute route

mkHalogenComponent
  :: forall q i o
   . { routeIO :: RouteIO Route }
  -> Halogen.Component q i o Aff
mkHalogenComponent { routeIO } =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval
        { handleAction = handleAction
        , initialize = Just Init
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
      ChameleonHalogen.runHalogenHtml $ ChildMsg <$> runStyleT html

  handleAction msg_ = do
    case msg_ of
      Init -> do
        _ <- subscribe (map MsgNewRoute $ makeEmitter routeIO.listen)
        pure unit

      MsgNewRoute route -> do
        H.modify_ $ routeSpec.updateStateFromRoute route

      ChildMsg msg -> do
        state <- get
        case routeSpec.mkRoute msg state of
          This route -> do
            liftEffect $ routeIO.pushRoute route

          That msg' -> do
            H.modify_ $ ui.update msg'

          Both route msg' -> do
            liftEffect $ routeIO.pushRoute route
            H.modify_ $ ui.update msg'

main :: Effect Unit
main = do
  routeIO <- ID.Routing.getRouteIO
  let
    halogenComponent = mkHalogenComponent { routeIO }

  HA.runHalogenAff do
    body <- HA.awaitBody
    _ <- runUI halogenComponent unit body
    pure unit
