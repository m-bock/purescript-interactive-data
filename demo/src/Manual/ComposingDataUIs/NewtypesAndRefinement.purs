{-
# Newtypes And Refinement

<!-- START hide -->
-}
module Manual.ComposingDataUIs.NewtypesAndRefinement where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Prelude

import Data.Newtype (class Newtype)
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->



-}

newtype UserId = UserId String

derive instance Newtype UserId _

instance Show UserId where
  show (UserId s) = "(UserId " <> show s <> ")"

{-

## Deriving Instances

-}

{-

## Composing a Data UI for the type

And then compose a data UI for it:

-}

demoSimpleNewtype :: DataUI' _ _ UserId
demoSimpleNewtype = ID.newtype_ (ID.TypeName "UserId")
  ID.string_

{-

{-

The UI will look like this:

<!-- START embed simpleNewtype 500 -->
<!-- END embed -->
-}