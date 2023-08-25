{-
# Data UIs for Primitive types

<!-- START hide -->
-}
module Manual.ComposingDataUIs.Primitives
  ( demoInt
  , demoString
  , sampleBoolean
  , sampleNumber
  )
  where

{-
<!-- END hide -->
<!-- START imports -->
-}

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

demoInt :: DataUI' _ _ Int
demoInt = ID.int
  { text: Just "The age of a person"
  , min: 0
  , max: 120
  }

{-
<!-- START embed int -->
<!-- END embed -->

## Boolean
-}

sampleBoolean :: DataUI' _ _ Boolean
sampleBoolean = ID.boolean_

{-
<!-- START embed boolean -->
<!-- END embed -->

## String
-}

demoString :: DataUI' _ _ String
demoString = ID.string {
  text: Just "The name of a person",
  maxLength:  Just 1
}

{-
<!-- START embed string -->
<!-- END embed -->

## Number
-}

sampleNumber :: DataUI' _ _ Number
sampleNumber = ID.number_

{-
<!-- START embed number -->
<!-- END embed -->
-}