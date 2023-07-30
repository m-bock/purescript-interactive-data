module InteractiveData.Run
  ( ctxNoWrap
  , getExtract
  , getUi
  , run
  ) where

import Prelude

import Data.Identity (Identity(..))
import Data.Maybe (Maybe)
import Data.Newtype (un)
import DataMVC.Types (DataResult, DataUI, DataUICtx(..), DataUiInterface(..))
import DataMVC.Types.DataUI (runDataUi)
import InteractiveData.Core (class IDHtml, DataTree(..), IDSurface, IDViewCtx)
import InteractiveData.Core.Types.IDDataUI (runIdSurface)
import InteractiveData.Core.Types.IDViewCtx (defaultViewCtx)
import InteractiveData.Run.Types.HtmlT (IDHtmlT, runIDHtmlT)
import MVC.Types (UI)
import VirtualDOM (class Html)

run
  :: forall html fm fs msg sta a
   . Html html
  => { name :: String
     , context :: DataUICtx (IDSurface (IDHtmlT html)) fm fs
     }
  -> DataUI (IDSurface (IDHtmlT html)) fm fs msg sta a
  -> DataUiInterface html msg sta a
run { name, context } dataUi =
  dataUi
    # flip runDataUi context
    # hoistSrf (runHtml { name })

getUi :: forall html msg sta a. { initData :: Maybe a } -> DataUiInterface html msg sta a -> UI html msg sta
getUi { initData } (DataUiInterface { view, init, update }) =
  { view
  , init: init initData
  , update
  }

getExtract :: forall html msg sta a. DataUiInterface html msg sta a -> (sta -> DataResult a)
getExtract (DataUiInterface { extract }) = extract

hoistSrf
  :: forall srf1 srf2 msg sta a. (srf1 ~> srf2) -> DataUiInterface srf1 msg sta a -> DataUiInterface srf2 msg sta a
hoistSrf nat (DataUiInterface itf) = DataUiInterface itf
  { view = itf.view >>> nat
  }

runHtml
  :: forall html msg
   . Html html
  => { name :: String }
  -> IDSurface (IDHtmlT html) msg
  -> html msg
runHtml { name } =
  let
    runSurface :: (IDSurface (IDHtmlT html)) msg -> (IDHtmlT html) msg
    runSurface = runIdSurface { path: [] } >>> un DataTree >>> _.view

    viewCtx :: IDViewCtx
    viewCtx = defaultViewCtx { label: name }

  in
    runSurface >>> runIDHtmlT viewCtx

ctxNoWrap :: forall html. IDHtml html => DataUICtx (IDSurface html) Identity Identity
ctxNoWrap = DataUICtx
  { wrap: \s -> s
      # imapMsg Identity (un Identity)
      # imapState Identity (un Identity)
  }

imapMsg
  :: forall srf msg1 msg2 sta a
   . Functor srf
  => (msg1 -> msg2)
  -> (msg2 -> msg1)
  -> DataUiInterface srf msg1 sta a
  -> DataUiInterface srf msg2 sta a
imapMsg mapMsg unmapMsg (DataUiInterface itf) = DataUiInterface
  { init: itf.init
  , update: \msg state -> itf.update (unmapMsg msg) state
  , view: itf.view >>> map mapMsg
  , extract: itf.extract
  , name: itf.name
  }

imapState
  :: forall srf msg sta1 sta2 a
   . Functor srf
  => (sta1 -> sta2)
  -> (sta2 -> sta1)
  -> DataUiInterface srf msg sta1 a
  -> DataUiInterface srf msg sta2 a
imapState mapState unmapState (DataUiInterface itf) = DataUiInterface
  { init: itf.init >>> mapState
  , update: \msg state -> mapState $ itf.update msg (unmapState state)
  , view: unmapState >>> itf.view
  , extract: unmapState >>> itf.extract
  , name: itf.name
  }

