{-
# Data UIs for Variant types

<!-- START hide -->
-}
module Manual.ComposingDataUIs.Variants where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Data.Maybe (Maybe(..))
import Data.Variant (Variant)
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->

...
-}

type RemoteData = Variant
  ( notAsked :: {}
  , loading :: { progress :: Number }
  , failed :: { errorMessage :: String, errorCode :: Int }
  , success :: { data :: String }
  )

demoVariant :: DataUI' _ _ RemoteData
demoVariant = ID.variant_ @"notAsked"
  { notAsked: ID.record_ {}
  , loading: ID.record_ { progress: ID.number_ }
  , failed: ID.record_ { errorMessage: ID.string_, errorCode: ID.int_ }
  , success: ID.record_ { data: ID.string_ }
  }

{-
<!-- START embed variant 700 -->
<!-- END embed -->
-}