module InteractiveData.DataUIs.Trivial
  ( TrivialCfg
  , mkTrivialDataUi
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import DataMVC.Types (DataUI(..), DataUiInterface(..))
import InteractiveData.Core (class IDHtml, DataAction, DataTree(..), DataTreeChildren(..), IDSurface(..))
import InteractiveData.Core.Classes.OptArgs (class OptArgs, getAllArgs)
import Prim.Row as Row
import Record (delete, union)
import Type.Proxy (Proxy(..))

type MkTrivialDataUiCfg html extraCfg a =
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
  => MkTrivialDataUiCfg html extraCfg a
  -> opt
  -> DataUI (IDSurface html) fm fs a a a
mkTrivialDataUi { view, init, typeName, actions, defaultConfig } opt =
  let
    defaultConfig'' :: TrivialCfg () a
    defaultConfig'' = { init: Nothing, text: Nothing }

    defaultConfig' :: TrivialCfg extraCfg a
    defaultConfig' = defaultConfig'' `union` defaultConfig

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