{-
# Polymorphic Data UIs

<!-- START hide -->
-}
module Manual.Polymorphic where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Prelude

import Chameleon (class Html)
import Data.Maybe (Maybe)
import Data.Variant (Variant)
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->
-}

type Sample = Array
  { task :: String
  , done :: Boolean
  , priority ::
      Variant
        ( "low" :: Unit
        , "medium" :: Unit
        , "high" :: Unit
        )
  , extraNote :: Maybe String
  }

demo
  :: forall html
   . Html html
  => DataUI' html _ _ Sample
demo = ID.dataUi

{-
<!-- START embed polymorphic 500 -->
<!-- END embed -->
-}