{-
# Data UIs for Record types

<!-- START hide -->
-}
module Manual.ComposingDataUIs.Records where

{-
<!-- END hide -->
<!-- START imports -->
-}

import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->

In the previous chapter we've seen how to create Data UIs for primitive data types.

Data UIs can also be created for Records. 

## Defining a Record type alias

Let's assume we have defined the following Record type alias:
-}

type User =
  { name :: String
  , age :: Int
  , address :: String
  }

{-

## Simple Data UIs without configuration
Now we can create a Data UI with the `record_` function like this:
-}

demoRecord :: DataUI' _ _ User
demoRecord =
  ID.record_
    { name: ID.string_
    , age: ID.int_
    , address: ID.string_
    }

{-

The UI will look like this:

<!-- START embed record 500 -->
<!-- END embed -->

## Using the general `dataUi` function

If you just want to use the default options for each field, you can also use the
general `dataUi` function. The actual Data UI will be derived by the type.
This example is equivalent to the `sampleRecord` value above.
-}

sampleRecord3 :: DataUI' _ _ User
sampleRecord3 = ID.dataUi

{-

## Using the `recordPartial_` function

For now we have seen two ways to create Data UIs for Records.
The first one is to use the `record_` function.
It is the most flexible way to create a Data UI for a Record.
But it is also the most verbose one.
Then there is the `dataUi` function.
It is the most concise way to create a Data UI for a Record.
But also there is no way to configure the Data UI.

Can we get the best of both worlds?
-}

sampleRecord4 :: DataUI' _ _ User
sampleRecord4 =
  ID.recordPartial_
    { name: ID.string_
    , age: ID.int_
    }

{-
As you can see, we can make use of the `recordPartial_` function.
It is similar to the `record_` function, but it allows us to omit some fields.
Here we have omitted the `address` field.
The omitted fields will be derived by the defaults for the type.

## What's behind the wildcards?

The wildcards contain the computed types for the `Msg` and `State` of the Data UI.
Usually you don't need to care about these types.
The larger your Data UIs get, the more nested these types will be.
So generally it's a good idea to either use the wildcards
or keep the final UI composition in a `let` or `where` clause.

Here's the same example as above, but with the wildcards expanded:
-}

sampleRecord5
  :: DataUI'
       ( ID.RecordMsg
           ( address :: ID.WrapMsg ID.StringMsg
           , age :: ID.WrapMsg ID.IntMsg
           , name :: ID.WrapMsg ID.StringMsg
           )
       )
       ( ID.RecordState
           ( address :: ID.WrapState ID.StringState
           , age :: ID.WrapState ID.IntState
           , name :: ID.WrapState ID.StringState
           )
       )
       User
sampleRecord5 = ID.dataUi
