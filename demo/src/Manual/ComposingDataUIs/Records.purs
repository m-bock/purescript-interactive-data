{-
# Data UIs for Record types

<!-- START hide -->
-}
module Manual.ComposingDataUIs.Records where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Data.Maybe (Maybe(..))
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->

In the previous chapter we've seen how to create Data UIs for primitive data types.

Data UIs can also be created for Records. Let's assume we have defined the following Record type alias:
-}

type User =
  { name :: String
  , age :: Int
  , address :: String
  }

{-

## Without configuration
Now we can create a Data UI with the `record_` function like this:
-}

sampleRecord :: DataUI' _ _ User
sampleRecord =
  ID.record_
    { name: ID.string_
    , age: ID.int_
    , address: ID.string_
    }

{-

## With configuration
If the `_` is omitted configuration options can be provided for the record. This
works exactly like the configuration for the primitive types:

-}

sampleRecordOpts :: DataUI' _ _ User
sampleRecordOpts =
  ID.record
    { text: Just "A sample User"
    }
    { name: ID.string_
    , age: ID.int { text: Just "The age of the user", min: 0, max: 100 }
    , address: ID.string_
    }

{-

## Using the general `dataUi` function

If you just want to use the default options for each field, you can also use the
general `dataUi` function. The actual Data UI will be derived by the type.
This example is equivalent to the `sampleRecord` value above.
-}

sampleRecord' :: DataUI' _ _ User
sampleRecord' = ID.dataUi