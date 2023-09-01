{-
# Simple Newtypes with Public Constructors

<!-- START hide -->
-}
module Manual.ComposingDataUIs.Newtypes.SimpleNewtypes where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Prelude

import Chameleon (class Html)
import Data.Newtype (class Newtype)
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

derive instance Newtype UserId _

instance Show UserId where
  show (UserId s) = "(UserId " <> show s <> ")"

{-

## Composing a Data UI for the newtype

And then compose a data UI for it:

-}

demo
  :: forall html
   . Html html
  => DataUI' html _ _ UserId
demo =
  ID.newtype_ (ID.TypeName "UserId")
    $ ID.string
        { multiline: false }

{-

The UI will look like this:

<!-- START embed simpleNewtype 500 -->
<!-- END embed -->
-}