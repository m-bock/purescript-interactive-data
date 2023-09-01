{-
# Data UIs for Primitive types

<!-- START hide -->
-}
module Manual.ComposingDataUIs.Primitives
  ( demoInt
  , demoString
  , demoBoolean
  , demoNumber
  ) where

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

The interactive-data library provides Data UIs for the following PureScript primitives:

- Integers
- Booleans
- Strings
- Numbers

## Int
-}

demoInt
  :: forall html
   . Html html
  => DataUI' html _ _ Int
demoInt =
  ID.int
    { text: Just "The age of a person"
    , min: 0
    , max: 120
    }

{-
<!-- START embed int 300 -->
<!-- END embed -->

## Boolean
-}

demoBoolean
  :: forall html
   . Html html
  => DataUI' html _ _ Boolean
demoBoolean =
  ID.boolean_

{-
<!-- START embed boolean 300 -->
<!-- END embed -->

## String
-}

demoString
  :: forall html
   . Html html
  => DataUI' html _ _ String
demoString =
  ID.string
    { text: Just "The name of a person"
    , maxLength: Just 100
    }

{-
<!-- START embed string 300 -->
<!-- END embed -->

## Number
-}

demoNumber
  :: forall html
   . Html html
  => DataUI' html _ _ Number
demoNumber =
  ID.number_

{-
<!-- START embed number -->
<!-- END embed -->
-}