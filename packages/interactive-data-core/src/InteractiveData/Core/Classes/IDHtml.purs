module InteractiveData.Core.Classes.IDHtml
  ( class IDHtml
  ) where

import InteractiveData.Core.Types.IDOutMsg (IDOutMsg)
import InteractiveData.Core.Types.IDViewCtx (IDViewCtx)
import Chameleon (class Html)
import Chameleon.Styled (class HtmlStyled)
import Chameleon.Transformers.Ctx.Class (class Ctx)
import Chameleon.Transformers.OutMsg.Class (class RunOutMsg)

class
  ( Html html
  , Ctx IDViewCtx html
  , RunOutMsg IDOutMsg html
  , HtmlStyled html
  ) <=
  IDHtml html
