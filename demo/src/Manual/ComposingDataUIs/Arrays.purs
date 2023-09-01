{-
# Data UIs for Arrays

<!-- START hide -->
-}
module Manual.ComposingDataUIs.Arrays where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Chameleon (class Html)
import Data.Maybe (Maybe(..))
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->
-}

demo
  :: forall html
   . Html html
  => DataUI' html _ _ (Array Int)
demo =
  ID.array { init: Just [ 1, 2, 3 ] }
    ID.int_

{-
<!-- START embed array 500 -->
<!-- END embed -->
-}