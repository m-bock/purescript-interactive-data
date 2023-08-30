module Landing.App where

import Chameleon as C
import Chameleon.Styled (class HtmlStyled)

view :: forall html msg. HtmlStyled html => html msg
view = C.div []
  [ C.text "Hello World!"
  ]