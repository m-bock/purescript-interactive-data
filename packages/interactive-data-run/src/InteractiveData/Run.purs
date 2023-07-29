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
import DataMVC.Types (DataResult, DataUI, DataUICtx(..), DataUiItf(..))
import DataMVC.Types.DataUI (applyWrap, runDataUi)
import InteractiveData.Core (class IDHtml, DataTree(..), IDSurface, IDViewCtx)
import InteractiveData.Core.Types.IDDataUI (runIdSurface)
import InteractiveData.Core.Types.IDViewCtx (defaultViewCtx)
import InteractiveData.Run.Types.HtmlT (IDHtmlT, runIDHtmlT)
import MVC.Types (UI)
import Unsafe.Coerce (unsafeCoerce)
import VirtualDOM (class Html)

run
  :: forall html fm fs msg sta a
   . Html html
  => { name :: String
     , initData :: Maybe a
     , context :: DataUICtx (IDSurface (IDHtmlT html)) fm fs
     }
  -> DataUI (IDSurface (IDHtmlT html)) fm fs msg sta a
  -> DataUiItf html  msg  sta a
run { name, initData, context } dataUi =
  dataUi
    -- # applyWrap
    # flip runDataUi context
    # hoistSrf'' (runHtml { name })

getUi :: forall html msg sta a. DataUiItf html msg sta a -> UI html msg sta
getUi = unsafeCoerce 1

getExtract :: forall html msg sta a. DataUiItf html msg sta a -> (sta -> DataResult a)
getExtract = unsafeCoerce 1

hoistSrf'
  :: forall srf1 srf2 fm fs msg sta a. (srf1 ~> srf2) -> DataUI srf1 fm fs msg sta a -> DataUI srf2 fm fs msg sta a
hoistSrf' nat ui = unsafeCoerce 1

hoistSrf'' :: forall srf1 srf2 fm fs msg sta a. (srf1 ~> srf2) -> DataUiItf srf1 msg sta a -> DataUiItf srf2 msg sta a
hoistSrf'' nat (DataUiItf itf) = DataUiItf itf
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

hoistSrf :: forall srf1 srf2 msg sta. (srf1 ~> srf2) -> UI srf1 msg sta -> UI srf2 msg sta
hoistSrf nat ui = ui
  { view = ui.view >>> nat
  }

dataUiItfToUI
  :: forall html msg sta a
   . Maybe a
  -> DataUiItf html msg sta a
  -> { ui :: UI html msg sta
     , extract :: sta -> DataResult a
     }
dataUiItfToUI init (DataUiItf dataUi) =
  { ui:
      { init: dataUi.init init
      , update: dataUi.update
      , view: dataUi.view
      }
  , extract: dataUi.extract
  }

imapMsg
  :: forall srf msg1 msg2 sta a
   . Functor srf
  => (msg1 -> msg2)
  -> (msg2 -> msg1)
  -> DataUiItf srf msg1 sta a
  -> DataUiItf srf msg2 sta a
imapMsg mapMsg unmapMsg (DataUiItf itf) = DataUiItf
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
  -> DataUiItf srf msg sta1 a
  -> DataUiItf srf msg sta2 a
imapState mapState unmapState (DataUiItf itf) = DataUiItf
  { init: itf.init >>> mapState
  , update: \msg state -> mapState $ itf.update msg (unmapState state)
  , view: unmapState >>> itf.view
  , extract: unmapState >>> itf.extract
  , name: itf.name
  }

