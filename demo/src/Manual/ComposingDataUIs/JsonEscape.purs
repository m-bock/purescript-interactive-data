{-
# Escape hatch: JSON Data UI

<!-- START hide -->
-}
module Manual.ComposingDataUIs.Newtypes.JsonEscape
  ( demo
  ) where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Chameleon (class Html)
import Data.Map (Map)
import Data.Map as Map
import Data.Tuple.Nested ((/\))
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->

-}

demo :: forall html. Html html => DataUI' html _ _ (Map Int String)
demo = ID.json
  { init: Map.fromFoldable
      [ 1 /\ "one"
      , 2 /\ "two"
      , 3 /\ "three"
      ]
  , typeName: "Map Int String"
  }

{-

The UI will look like this:

<!-- START embed jsonEscape 500 -->
<!-- END embed -->
-}