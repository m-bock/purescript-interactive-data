module InteractiveData.Entry
  ( InteractiveDataApp
  , SimpleDataUI
  , ToAppCfg
  , ToAppMandatory
  , ToAppOptional
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
import InteractiveData.Core (class IDHtml, IDSurface)
import InteractiveData.Core.Classes.OptArgs (class OptArgsMixed, getAllArgsMixed)
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

type SimpleDataUI msg sta typ =
  forall html
   . IDHtml html
  => DataUI (IDSurface html) WrapMsg WrapState msg sta typ

--------------------------------------------------------------------------------
--- Functions
--------------------------------------------------------------------------------

type ToAppCfg a = Record (ToAppMandatory (ToAppOptional a ()))

type ToAppMandatory r =
  ( name :: String
  | r
  )

type ToAppOptional a r =
  ( initData :: Maybe a
  , fullscreen :: Boolean
  , showLogo :: Boolean
  | r
  )

defaultToAppCfg :: forall a. Record (ToAppOptional a ())
defaultToAppCfg =
  { initData: Nothing
  , fullscreen: false
  , showLogo: true
  }

toApp
  :: forall html given msg sta a
   . Html html
  => OptArgsMixed
       (ToAppCfg a)
       (ToAppOptional a ())
       given
  => given
  -> DataUI (IDSurface (IDHtmlT html)) WrapMsg WrapState msg sta a
  -> InteractiveDataApp html (AppMsg (WrapMsg msg)) (AppState (WrapState sta)) a
toApp given dataUi =
  let
    cfg :: ToAppCfg a
    cfg = getAllArgsMixed defaultToAppCfg given

    { name, fullscreen, initData, showLogo } = cfg

    interface :: DataUiInterface html (AppMsg (WrapMsg msg)) (AppState (WrapState sta)) a
    interface =
      Run.run
        { name
        , context: App.WrapData.dataUiCtx
        , fullscreen
        , showLogo
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