module InteractiveData.TrivialDataUI where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import DataMVC.Types (DataUI(..), DataUiInterface(..))
import InteractiveData.Core (class IDHtml, DataAction, DataTree(..), DataTreeChildren(..), IDSurface(..))
import InteractiveData.Core.Classes.OptArgs (class OptArgs, getAllArgs)
import InteractiveData.Core.Util.RecordProjection (pick)
import Prim.Row (class Union)
import Prim.Row as Row
import Record (delete, merge, union)
import Type.Proxy (Proxy(..))

type Cfg html extraCfg a =
  { init :: a
  , view :: Record extraCfg -> a -> html a
  , typeName :: String
  , actions :: a -> Array (DataAction a)
  , defaultConfig :: Record extraCfg
  }

type TrivialCfg extraCfg a =
  { init :: Maybe a
  , text :: Maybe String
  | extraCfg
  }

mkTrivialDataUi
  :: forall html opt extraCfg fm fs a
   . IDHtml html
  => OptArgs (TrivialCfg extraCfg a) opt
  => Row.Lacks "init" extraCfg
  => Row.Lacks "text" extraCfg
  => Cfg html extraCfg a
  -> opt
  -> DataUI (IDSurface html) fm fs a a a
mkTrivialDataUi { view, init, typeName, actions, defaultConfig } opt =
  let
    a :: TrivialCfg () a
    a = { init: Nothing, text: Nothing }

    defaultConfig' :: TrivialCfg extraCfg a
    defaultConfig' = a `union` defaultConfig

    cfg :: TrivialCfg extraCfg a
    cfg = getAllArgs defaultConfig' opt

    cfg' :: Record extraCfg
    cfg' = cfg
      # delete (Proxy :: Proxy "init")
      # delete (Proxy :: Proxy "text")
  in
    DataUI \_ -> DataUiInterface
      { name: typeName
      , view: \state -> IDSurface \_ ->
          DataTree
            { view: view cfg' state
            , actions: actions state
            , children: Fields []
            , meta: Nothing
            , text: cfg.text
            }
      , extract: Right
      , update: \a _ -> a
      , init: case _ of
          Nothing -> case cfg.init of
            Just x -> x
            Nothing -> init
          Just x -> x
      }