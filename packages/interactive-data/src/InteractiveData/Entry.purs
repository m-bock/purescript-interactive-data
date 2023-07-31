module InteractiveData.Entry
  ( InteractiveDataApp
  , toApp
  ) where

import Prelude

import Data.Maybe (Maybe)
import DataMVC.Types (DataUI, DataUiInterface, DataResult)
import InteractiveData.App (AppMsg, AppState)
import InteractiveData.App as App
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.App.WrapData as App.WrapData
import InteractiveData.Core (IDSurface)
import InteractiveData.Run as Run
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import MVC.Types (UI)
import Chameleon (class Html)

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

toApp
  :: forall html msg sta a
   . Html html
  => { name :: String
     , initData :: Maybe a
     , fullscreen :: Boolean
     }
  -> DataUI (IDSurface (IDHtmlT html)) WrapMsg WrapState msg sta a
  -> InteractiveDataApp html (AppMsg (WrapMsg msg)) (AppState (WrapState sta)) a
toApp { name, fullscreen, initData } dataUi =
  let
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