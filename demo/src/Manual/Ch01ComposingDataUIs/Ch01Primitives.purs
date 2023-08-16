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
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->

The interactive-data library provides Data UIs for the following PureScript primitives:

- Integers
- Booleans
- Strings
- Numbers

## Usage without options

Each primitive can be either created without extra configuration. E.g.:

-}

sampleInt :: DataUI' _ _ Int
sampleInt = ID.int_

sampleBoolean :: DataUI' _ _ Boolean
sampleBoolean = ID.boolean_

sampleString :: DataUI' _ _ String
sampleString = ID.string_

sampleNumber :: DataUI' _ _ Number
sampleNumber = ID.number_

{-

`DataUI'` is a simplification of the `DataUI` type.
It hides some type arguments and constraints
which are not so important in the beginnig.
It will be used in most of the examples.

## Configure options, example for `Int`

Otherwise if the `_` is omitted some configuration options can be provided.
Int the following example a descriptive text is added
and the UI is limited to only create integer values between `0` and `100`.

-}

sampleIntWithOpts :: DataUI' _ _ Int
sampleIntWithOpts = ID.int
  { text: Just "The Age of a person"
  , min: 0
  , max: 100
  }

{-
Note that this boundaries are only existant on the UI level.
In one of the following chapters you'll see how you can go a step further
and add restrictions on the type level with a smart constructor refinement.

Some configuration options are applicable to every Data UI (e.g. `text`),
others a specific for each type. Refer to the API docs to see which ones are
available.

## X

There is also a polymorphic way to create primitive Data UIs. In this case no configuration options can be provided.
-}

sampleInt' :: DataUI' _ _ Int
sampleInt' = ID.dataUi
