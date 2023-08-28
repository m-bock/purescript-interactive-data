{-
# Data UIs for Record types

<!-- START hide -->
-}
module Manual.ComposingDataUIs.Records where

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

## Create Data UI for the specific Record type
Now we can create a Data UI with the `record_` function like this:
-}

demoRecord :: forall html. Html html => DataUI' html _ _ User
demoRecord =
  ID.record_
    { name: ID.string_
    , age: ID.int_
    , address: ID.string { text: Just "Street and zip code" }
    }

{-

The UI will look like this:

<!-- START embed record 500 -->
<!-- END embed -->

## What's behind the wildcards?

The wildcards contain the computed types for the `Msg` and `State` of the Data UI.
Usually you don't need to care about these types.
The larger your Data UIs get, the more nested these types will be.
So generally it's a good idea to either use the wildcards
or keep the final UI composition in a `let` or `where` clause.

Here's the same example as above, but with the wildcards expanded:
-}

sampleRecord5
  :: forall html
   . Html html
  => DataUI' html
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
