module Demo.Common.Features.Refinement.ArchiveID
  ( ArchiveID
  , archiveID_
  , mkArchiveID
  , print
  , sampleArchiveID
  ) where

import Prelude

import Data.Argonaut (class DecodeJson, class EncodeJson)
import Data.Char (toCharCode)
import Data.Either (note)
import Data.Foldable (all)
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (toCharArray)
import InteractiveData
  ( class IDDataUI
  , class IDHtml
  , DataError(..)
  , DataErrorCase(..)
  , DataUI
  , IDSurface
  , StringMsg
  , StringState
  )
import InteractiveData as ID

sampleArchiveID :: ArchiveID
sampleArchiveID = ArchiveID "abcdefg"

print :: ArchiveID -> String
print (ArchiveID x) = x

newtype ArchiveID = ArchiveID String

derive newtype instance EncodeJson ArchiveID
derive newtype instance DecodeJson ArchiveID
derive newtype instance Show ArchiveID

mkArchiveID :: String -> Maybe ArchiveID
mkArchiveID candidate =
  let
    chars :: Array Char
    chars = toCharArray candidate
  in
    if all isLowercaseAlpha chars then Just $ ArchiveID candidate
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

archiveID_
  :: forall html fm fs
   . IDHtml html
  => DataUI (IDSurface html) fm fs StringMsg StringState ArchiveID
archiveID_ =
  ID.string_
    # ID.refineDataUi
        { typeName: "ArchiveID"
        , refine: mkArchiveID >>>
            note (pure $ DataError [] $ DataErrMsg "Invalid ArchiveID. Must contain only lowercase alpha characters.")
        , unrefine: \(ArchiveID x) -> x
        }

--------------------------------------------------------------------------------
--- Instance
--------------------------------------------------------------------------------

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs StringMsg StringState ArchiveID
  where
  dataUi = archiveID_