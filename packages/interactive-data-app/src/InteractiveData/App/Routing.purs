module InteractiveData.App.Routing
  ( route
  , routeSpec
  ) where

import Prelude

import Data.These (These(..))
import InteractiveData.App.WrapApp (AppMsg, AppSelfMsg(..), AppState(..))
import InteractiveData.Core (IDOutMsg(..))
import Routing.Duplex (RouteDuplex')
import Routing.Duplex as RD
import Type.Proxy (Proxy(..))

type Route =
  { state :: Array String
  }

updateStateFromRoute :: forall sta. Route -> AppState sta -> AppState sta
updateStateFromRoute { state } (AppState state') = AppState state' { selectedPath = state }

mkRoute :: forall msg sta. AppMsg msg -> AppState sta -> These Route (AppMsg msg)
mkRoute msg _ = case msg of
  This (SetSelectedPath path) ->
    This { state: path }

  This (MenuMsg (That (SetSelectedPath path))) ->
    This { state: path }

  That (GlobalSelectDataPath path) ->
    This { state: path }

  Both (SetSelectedPath path) (GlobalSelectDataPath _) ->
    This { state: path }

  Both (MenuMsg (That (SetSelectedPath path))) (GlobalSelectDataPath _) ->
    This { state: path }

  Both _ (GlobalSelectDataPath path) ->
    Both { state: path } msg

  _ ->
    That msg

route :: RouteDuplex' Route
route = RD.root $ RD.record
  # RD.prop (Proxy :: Proxy "state") (RD.many RD.segment)

type RouteSpec route msg sta =
  { updateStateFromRoute :: route -> sta -> sta
  , mkRoute :: msg -> sta -> These route msg
  }

routeSpec :: forall msg sta. RouteSpec Route (AppMsg msg) (AppState sta)
routeSpec =
  { mkRoute
  , updateStateFromRoute
  }
