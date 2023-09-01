{-
# Data UIs for custom Types

<!-- START hide -->
-}
module Manual.ComposingDataUIs.CustomTypes where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Prelude

import Chameleon (class Html)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import InteractiveData (DataUI', (~))
import InteractiveData as ID

{-
<!-- END imports -->

## Defining a custom data type

Define a custom data type first:

-}
data CustomADT
  = Foo Int
  | Bar String
  | Baz Number Boolean
  | Qux

{-

## Deriving Instances

Then derive `Generic` and `Show` instances for it:

-}

derive instance Generic CustomADT _

instance Show CustomADT where
  show = genericShow

{-

## Composing a Data UI for the type

And then compose a data UI for it:

-}

demoCustomType
  :: forall html
   . Html html
  => DataUI' html _ _ CustomADT
demoCustomType =
  ID.generic_ @"Foo" (ID.TypeName "CustomADT")
    { "Foo": ID.int_
    , "Bar": ID.string_
    , "Baz": ID.number_ ~ ID.boolean_
    , "Qux": unit
    }

{-

The UI will look like this:

<!-- START embed customType 500 -->
<!-- END embed -->
-}