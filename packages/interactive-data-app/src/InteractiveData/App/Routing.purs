module InteractiveData.App.Routing
  ( Route
  , RouteIO
  , getRouteIO
  , routeSpec
  )
  where

import Prelude

import Data.Maybe (fromMaybe)
import Data.String as Str
import Data.These (These(..))
import Effect (Effect)
import Foreign (unsafeToForeign)
import InteractiveData.App.EnvVars (envVars)
import InteractiveData.App.WrapApp (AppMsg, AppSelfMsg(..), AppState(..))
import InteractiveData.Core (IDOutMsg(..))
import Routing.Duplex (RouteDuplex')
import Routing.Duplex as RD
import Routing.PushState (PushStateInterface)
import Routing.PushState as R
import Routing.PushState as Routing
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
route =
  RD.root $ RD.record
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

getRouteIO :: Effect (RouteIO Route)
getRouteIO = getRouteIO_ route

--------------------------------------------------------------------------------
--- Route IO
--------------------------------------------------------------------------------

type RouteIO route =
  { pushRoute :: route -> Effect Unit
  , listen :: (route -> Effect Unit) -> Effect (Effect Unit)
  }

getRouteIO_ :: forall route. RouteDuplex' route -> Effect (RouteIO route)
getRouteIO_ routeDuplex = do
  routeInterface :: PushStateInterface <- Routing.makeInterface

  let
    stripPrefix :: String -> String
    stripPrefix str = Str.stripPrefix (Str.Pattern envVars.prefix) str
      # fromMaybe str

    addPrefix :: String -> String
    addPrefix str = envVars.prefix <> str

    pushRoute :: route -> Effect Unit
    pushRoute route' =
      routeInterface.pushState
        (unsafeToForeign {})
        (RD.print routeDuplex route' # addPrefix)

    listen :: (route -> Effect Unit) -> Effect (Effect Unit)
    listen emitRoute =
      R.matchesWith
        (stripPrefix >>> RD.parse routeDuplex)
        (\_ newRoute -> emitRoute newRoute)
        routeInterface

  pure
    { pushRoute
    , listen
    }
