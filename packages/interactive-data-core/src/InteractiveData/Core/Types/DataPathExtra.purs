module InteractiveData.Core.Types.DataPathExtra where

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
  loop accum strPath (DataTree { children }) = case Array.uncons strPath, children of
    Nothing, _ ->
      Just accum

    Just { head, tail },
    Case (caseTree /\ tree)
      | head == caseTree ->
          loop (accum <> [ SegCase head ]) tail tree

    Just { head, tail },
    Fields fields
      | (Just (key /\ tree)) <- Array.find (fst >>> (isDataPathSegmentField head)) fields ->
          loop (accum <> [ SegField key ]) tail tree

    _, _ -> Nothing

isDataPathSegmentField :: String -> DataPathSegmentField -> Boolean
isDataPathSegmentField str = case _ of
  SegStaticKey s -> str == s
  SegStaticIndex i -> str == show i
  SegDynamicKey s -> str == s
  SegDynamicIndex i -> str == show i
  SegVirtualKey s -> str == s

dataPathToStrings :: DataPath -> Array String
dataPathToStrings = map segmentToString

segmentToString :: DataPathSegment -> String
segmentToString = case _ of
  SegCase s -> s
  SegField x -> case x of
    SegStaticKey s -> s
    SegStaticIndex i -> show i
    SegDynamicKey s -> s
    SegDynamicIndex i -> show i
    SegVirtualKey s -> s
