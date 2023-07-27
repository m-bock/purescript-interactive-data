module InteractiveData.Core.Classes.IDHtml
  ( class IDHtml
  ) where

import InteractiveData.Core.Types.IDOutMsg (IDOutMsg)
import InteractiveData.Core.Types.IDViewCtx (IDViewCtx)
import VirtualDOM (class Html)
import VirtualDOM.Styled (class RegisterStyleMap)
import VirtualDOM.Transformers.Ctx.Class (class Ctx)
import VirtualDOM.Transformers.OutMsg.Class (class RunOutMsg)

class
  ( Html html
  , Ctx IDViewCtx html
  , RunOutMsg IDOutMsg html
  , RegisterStyleMap html
  ) <=
  IDHtml html
