{-
# Newtypes with smart constructors

<!-- START hide -->
-}
module Manual.ComposingDataUIs.Newtypes.SmartConstructor where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Prelude

import Data.Either (Either(..))
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->

## Define a newtype around a type
-}

newtype UserId = UserId String

{-

## Define Instances

-}

instance Show UserId where
  show (UserId s) = "(unsafeFromString " <> show s <> ")"

{-

## Composing a Data UI for the newtype

And then compose a data UI for it:

-}

demo :: DataUI' _ _ UserId
demo = ID.refineDataUi
  { typeName: "UserId"
  , refine: UserId >>> Right
  , unrefine: \(UserId s) -> s
  }
  (ID.string { multiline: false })

{-

{-

The UI will look like this:

<!-- START embed newtypeSmart 500 -->
<!-- END embed -->
-}