module InteractiveData.Run.Types.HtmlT
  ( IDHtmlT
  , runIDHtmlT
  ) where

import Prelude

import InteractiveData.Core (class IDHtml, IDOutMsg, IDViewCtx)
import VirtualDOM (class Html, class MaybeMsg)
import VirtualDOM.Styled (class RegisterStyleMap, StyleT, runStyleT)
import VirtualDOM.Transformers.Ctx.Class (class AskCtx, class Ctx)
import VirtualDOM.Transformers.Ctx.Trans (CtxT, runCtxT)
import VirtualDOM.Transformers.OutMsg.Class (class OutMsg, class RunOutMsg)
import VirtualDOM.Transformers.OutMsg.Trans (OutMsgT, runOutMsgT)

newtype IDHtmlT html a = IDHtmlT
  ( CtxT IDViewCtx
      ( StyleT
          (OutMsgT IDOutMsg html)
      )
      a
  )

derive newtype instance Html html => Html (IDHtmlT html)

derive newtype instance AskCtx IDViewCtx (IDHtmlT html)

derive newtype instance Ctx IDViewCtx (IDHtmlT html)

derive newtype instance Html html => OutMsg IDOutMsg (IDHtmlT html)

derive newtype instance Html html => RunOutMsg IDOutMsg (IDHtmlT html)

derive instance Functor html => Functor (IDHtmlT html)

derive newtype instance RegisterStyleMap (IDHtmlT html)

instance (Html html) => IDHtml (IDHtmlT html)

runIDHtmlT
  :: forall html msg
   . Functor html
  => Html html
  => MaybeMsg html
  => IDViewCtx
  -> IDHtmlT html msg
  -> html msg
runIDHtmlT viewCtx (IDHtmlT idHtml) =
  let
    styleHtml :: StyleT (OutMsgT IDOutMsg html) msg
    styleHtml = runCtxT idHtml viewCtx

    outMsgHtml :: OutMsgT IDOutMsg html msg
    outMsgHtml = runStyleT styleHtml
  in
    runOutMsgT outMsgHtml

