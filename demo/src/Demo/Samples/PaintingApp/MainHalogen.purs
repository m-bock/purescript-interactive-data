module Demo.Samples.PaintingApp.MainHalogen
  ( main
  ) where

import Prelude

import Chameleon.Impl.Halogen as ChameleonHalogen
import Chameleon.Styled (runStyleT)
import Data.Maybe (Maybe(..))
import Data.These (These(..))
import Demo.Common.Embedded as UIEmbedded
import Demo.Samples.PaintingApp.Types (Painting)
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen (get, liftEffect, subscribe)
import Halogen as H
import Halogen as Halogen
import Halogen.Aff as HA
import Halogen.HTML (HTML)
import Halogen.Subscription (makeEmitter)
import Halogen.VDom.Driver (runUI)
import InteractiveData.App.Routing (RouteIO, Route, routeSpec)
import InteractiveData.App.Routing as ID.Routing
import InteractiveData as ID

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
      dataResult :: ID.DataResult Painting
      dataResult = extract state

      halogenRender :: ID.DataResult Painting -> HTML _ (Msg Route (ID.AppMsg _))
      halogenRender result =
        UIEmbedded.view
          { viewInteractiveData: ui.view state
          }
          result
          # runStyleT
          # ChameleonHalogen.runHalogenHtml
          <#> ChildMsg

    in
      halogenRender dataResult

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
