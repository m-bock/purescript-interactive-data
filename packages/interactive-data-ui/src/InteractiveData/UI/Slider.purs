module InteractiveData.UI.Slider where

import Chameleon (class Html)
import Chameleon as C

view :: forall html msg. Html html => {} -> html msg
view _ = C.text "slider"