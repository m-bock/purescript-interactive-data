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

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import InteractiveData (DataUI, DataUI', IDSurface, (~))
import InteractiveData as ID

{-
<!-- END imports -->

Define a custom data type first:

-}
data CustomADT
  = Foo Int
  | Bar String
  | Baz Number Boolean
  | Qux

{-

Then derive `Generic` and `Show` instances for it:

-}

derive instance Generic CustomADT _

instance Show CustomADT where
  show = genericShow

{-

Then define a generic data UI for it:

-}

customADT
  :: forall opt html fm fs datauis msg sta
   . ID.GenericDataUI opt html fm fs "Foo" datauis msg sta CustomADT
  => opt
  -> { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta CustomADT
customADT = ID.generic
  { typeName: "CustomADT"
  }

{-

And then compose a data UI for it:

-}

demoCustomType :: DataUI' _ _ CustomADT
demoCustomType = customADT {}
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