module Demo.Common.Features.Refinement.UserID
  ( UserID
  , mkUserID
  , userId_
  ) where

import Prelude

import Data.Argonaut (class DecodeJson, class EncodeJson)
import Data.Char (toCharCode)
import Data.Either (note)
import Data.Foldable (all)
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (toCharArray)
import InteractiveData (class IDHtml, DataError(..), DataErrorCase(..), DataUI, IDSurface, StringMsg, StringState)
import InteractiveData as ID

newtype UserID = UserID String

derive newtype instance EncodeJson UserID
derive newtype instance DecodeJson UserID
derive newtype instance Show UserID

mkUserID :: String -> Maybe UserID
mkUserID candidate =
  let
    chars :: Array Char
    chars = toCharArray candidate
  in
    if all isLowercaseAlpha chars then Just $ UserID candidate
    else Nothing

isLowercaseAlpha :: Char -> Boolean
isLowercaseAlpha char =
  let
    charCode :: Int
    charCode = toCharCode char
  in
    charCode >= 97 && charCode <= 122

--------------------------------------------------------------------------------
--- DataUI
--------------------------------------------------------------------------------

userId_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs StringMsg StringState UserID
userId_ =
  ID.string_
    # ID.refineDataUi
        { typeName: "UserID"
        , refine: mkUserID >>>
            note (pure $ DataError [] $ DataErrMsg "Invalid UserID. Must contain only lowercase alpha characters.")
        , unrefine: \(UserID x) -> x
        }