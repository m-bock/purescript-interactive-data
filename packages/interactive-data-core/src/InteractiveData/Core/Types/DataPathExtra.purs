module InteractiveData.Core.Types.DataPathExtra
  ( dataPathFromStrings
  , dataPathToStrings
  , segmentToString
  ) where

import Prelude

import Data.Array as Array
import Data.Maybe (Maybe(..))
import Data.Tuple (fst)
import Data.Tuple.Nested ((/\))
import DataMVC.Types (DataPath, DataPathSegment(..), DataPathSegmentField(..))
import InteractiveData.Core.Types.DataTree (DataTree(..), DataTreeChildren(..))

dataPathFromStrings :: forall srf msg. Array String -> DataTree srf msg -> Maybe DataPath
dataPathFromStrings = loop []
  where

  loop :: Array DataPathSegment -> Array String -> DataTree srf msg -> Maybe (Array DataPathSegment)
  loop accum strPath (DataTree { children }) =
    let
      unconsResult :: Maybe { head :: String, tail :: Array String }
      unconsResult = Array.uncons strPath
    in
      case { unconsResult, children } of
        { unconsResult: Nothing
        , children: _
        } ->
          Just accum

        { unconsResult: Just { head, tail }
        , children: Case (caseTree /\ tree)
        }
          | head == caseTree ->
              loop (accum <> [ SegCase head ]) tail tree

        { unconsResult: Just { head, tail }
        , children: Fields fields
        } -> do
          key /\ tree <- Array.find (fst >>> (isDataPathSegmentField head)) fields
          loop (accum <> [ SegField key ]) tail tree

        { unconsResult: Just _
        , children: _
        } ->
          Nothing

isDataPathSegmentField :: String -> DataPathSegmentField -> Boolean
isDataPathSegmentField str = case _ of
  SegStaticKey keyStr -> str == keyStr
  SegStaticIndex index -> str == show index
  SegDynamicKey keyStr -> str == keyStr
  SegDynamicIndex index -> str == show index
  SegVirtualKey keyStr -> str == keyStr

dataPathToStrings :: DataPath -> Array String
dataPathToStrings = map segmentToString

segmentToString :: DataPathSegment -> String
segmentToString = case _ of
  SegCase caseStr -> caseStr
  SegField field -> fieldToString field

fieldToString :: DataPathSegmentField -> String
fieldToString = case _ of
  SegStaticKey keyStr -> keyStr
  SegStaticIndex index -> show index
  SegDynamicKey keyStr -> keyStr
  SegDynamicIndex index -> show index
  SegVirtualKey keyStr -> keyStr
