{-
<!-- START hide -->
-}
module Manual.RunningDataUIs
  ( MyType
  , myApp
  , myDataUi
  ) where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Chameleon (class Html)
import Data.Maybe (Maybe(..))
import InteractiveData (DataUI', InteractiveDataApp)
import InteractiveData as ID

{-
<!-- END imports -->

# Running Data UIs

The `interactive-data` library is framework agnostic.
It is up to the user to provide the necessary plumbing to run the UI.
However, the following step is needed across all frameworks:
Before the UI can be run, it needs to be turned into an app representation.

## Data UI for a type 

Nothing new here, we just create a `DataUI'` for a type.
-}

type MyType =
  { firstName :: String
  , lastName :: String
  }

myDataUi
  :: forall html
   . Html html
  => DataUI' html _ _ MyType
myDataUi =
  ID.record_
    { firstName: ID.string_
    , lastName: ID.string_
    }

{-
## Wrap the Data UI in an app

We finalize the Data UI by using the `toApp` function
which takes a `DataUI'` along with some configuration options
and returns an `InteractiveDataApp`. 
-}

myApp
  :: forall html
   . Html html
  => InteractiveDataApp html _ _ MyType
myApp = ID.toApp
  { name: "My App"
  , initData: Nothing
  , fullscreen: false
  , showMenuOnStart: true
  }
  myDataUi