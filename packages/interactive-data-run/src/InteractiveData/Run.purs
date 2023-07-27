module InteractiveData.Run where

import Data.Identity (Identity)
import InteractiveData.Core
  ( DataUI
  , DataUICtx(..)
  , runDataUi
  , class IDHtml
  , DataResult
  , DataUiItf
  , IDSurface
  )
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import MVC.Types (UI)
import Unsafe.Coerce (unsafeCoerce)
import VirtualDOM (class Html)

f
  :: forall html fm fs msg sta a
   . Html html
  => DataUICtx (IDSurface (IDHtmlT html)) fm fs
  -> DataUI (IDSurface (IDHtmlT html)) fm fs msg sta a
  -> { ui :: UI html (fm msg) (fs sta)
     , extract :: fs sta -> DataResult a
     }
f ctx idDataUi =
  let
    dataUiItf :: DataUiItf (IDSurface (IDHtmlT html)) msg sta a
    dataUiItf = runDataUi idDataUi ctx
  in
    unsafeCoerce 1

ctxNoWrap :: forall html. IDHtml html => DataUICtx (IDSurface html) Identity Identity
ctxNoWrap = DataUICtx { wrap: \s -> unsafeCoerce 1 }