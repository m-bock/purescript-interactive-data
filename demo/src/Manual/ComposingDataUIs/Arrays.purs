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
import Data.Maybe (Maybe)
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->
-}

demo :: forall html. Html html => DataUI' html _ _ (Array (Maybe Int))
demo =
  ID.array_ ID.dataUi

{-
<!-- START embed array 500 -->
<!-- END embed -->
-}