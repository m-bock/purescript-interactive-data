{-
# Data UIs for Primitive types

<!-- START hide -->
-}
module Manual.Ch01ComposingDataUIs.Ch01Primitives where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Data.Maybe (Maybe(..))
import InteractiveData (SimpleDataUI)
import InteractiveData as ID

{-
<!-- END imports -->

The interactive-data library provides Data UIs for the following PureScript primitives:

- Integers
- Booleans
- Strings
- Numbers

Each primitive can be either created without extra configuration. E.g.:

-}

sampleInt :: SimpleDataUI _ _ Int
sampleInt = ID.int_

sampleBoolean :: SimpleDataUI _ _ Boolean
sampleBoolean = ID.boolean_

sampleString :: SimpleDataUI _ _ String
sampleString = ID.string_

sampleNumber :: SimpleDataUI _ _ Number
sampleNumber = ID.number_

{-

Otherwise if the `_` is omitted some configuration options can be provided:

-}

sampleIntWithOpts :: SimpleDataUI _ _ Int
sampleIntWithOpts = ID.int
  { text: Just "The Age of a person"
  , min: 0
  , max: 100
  }

{-
Some configuration options are applicable to every Data UI (e.g. `text`),
others a specific for each type. Refer to the API docs to see which ones are
available.

There is also a polymorphic way to create primitive Data UIs. In this case no configuration options can be provided.
-}

sampleInt' :: SimpleDataUI _ _ Int
sampleInt' = ID.dataUi
