{-
# Maybe and friends

<!-- START hide -->
-}
module Manual.ComposingDataUIs.MaybeAndFriends where

{-
<!-- END hide -->
<!-- START imports -->
-}

import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple)
import InteractiveData (DataUI')
import InteractiveData as ID

{-
<!-- END imports -->

the interactive-data library provides Data UIs for common data types
like `Maybe`, `Either` and `Tuple`.


# Maybe

-}

dataUiMaybe1 :: DataUI' _ _ (Maybe Int)
dataUiMaybe1 = ID.maybe_ ID.int_

dataUiMaybe2 :: DataUI' _ _ (Maybe Int)
dataUiMaybe2 = ID.maybe
  { text: Just "Call me maybe.." }
  ID.int_

{-

# Either

-}

dataUiEither1 :: DataUI' _ _ (Either Int String)
dataUiEither1 = ID.either_ ID.int_ ID.string_

dataUiEither2 :: DataUI' _ _ (Either String Int)
dataUiEither2 = ID.either
  { text: Just "Some Result or some Error" }
  ID.string_
  ID.int_

{-

# Tuple

-}

dataUiTuple1 :: DataUI' _ _ (Tuple Int String)
dataUiTuple1 = ID.tuple_ ID.int_ ID.string_

dataUiTuple2 :: DataUI' _ _ (Tuple Int String)
dataUiTuple2 = ID.tuple
  { text: Just "Int and String" }
  ID.int_
  ID.string_

{-