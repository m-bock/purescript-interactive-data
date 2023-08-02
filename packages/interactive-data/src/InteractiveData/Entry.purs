module InteractiveData.Entry
  ( InteractiveDataApp
  , ToAppCfg
  , ToAppOpt
  , defaultToAppCfg
  , toApp
  ) where

import Prelude

import Chameleon (class Html)
import Data.Maybe (Maybe(..))
import DataMVC.Types (DataUI, DataUiInterface, DataResult)
import InteractiveData.App (AppMsg, AppState)
import InteractiveData.App as App
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.App.WrapData as App.WrapData
import InteractiveData.Core (IDSurface)
import InteractiveData.Core.Classes.OptArgs (class MixedOptArgs, mixedGetAllArgs)
import InteractiveData.Run as Run
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import MVC.Types (UI)

--------------------------------------------------------------------------------
--- Types
--------------------------------------------------------------------------------

type InteractiveDataApp html msg sta a =
  { ui :: UI html msg sta
  , extract :: sta -> DataResult a
  }

--------------------------------------------------------------------------------
--- Functions
--------------------------------------------------------------------------------

type ToAppCfg a =
  { name :: String
  | ToAppOpt a
  }

type ToAppOpt a =
  ( initData :: Maybe a
  , fullscreen :: Boolean
  )

defaultToAppCfg :: forall a. Record (ToAppOpt a)
defaultToAppCfg =
  { initData: Nothing
  , fullscreen: false
  }

toApp
  :: forall html opt msg sta a
   . Html html
  => MixedOptArgs (ToAppCfg a) (ToAppOpt a) opt
  => opt
  -> DataUI (IDSurface (IDHtmlT html)) WrapMsg WrapState msg sta a
  -> InteractiveDataApp html (AppMsg (WrapMsg msg)) (AppState (WrapState sta)) a
toApp opt dataUi =
  let
    cfg :: ToAppCfg a
    cfg = mixedGetAllArgs defaultToAppCfg opt

    { name, fullscreen, initData } = cfg

    interface :: DataUiInterface html (AppMsg (WrapMsg msg)) (AppState (WrapState sta)) a
    interface =
      Run.run
        { name
        , context: App.WrapData.dataUiCtx
        , fullscreen
        }
        $ App.wrapApp dataUi

    ui :: UI html (AppMsg (WrapMsg msg)) (AppState (WrapState sta))
    ui = Run.getUi { initData } interface

    extract :: AppState (WrapState sta) -> DataResult a
    extract = Run.getExtract interface
  in
    { ui
    , extract
    }