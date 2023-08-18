module InteractiveData.Core.Types.DataTree
  ( DataTree(..)
  , DataTreeChildren(..)
  , TreeMeta
  , digTrivialTrees
  , find
  , hasNoChildren
  , mapMetadataAlongPath
  , setChildren
  ) where

import Prelude

import Data.Array as Array
import Data.Eq (class Eq1)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, over)
import Data.Ord (class Ord1)
import Data.Tuple (fst)
import Data.Tuple.Nested (type (/\), (/\))
import DataMVC.Types (DataPath, DataPathSegment(..), DataPathSegmentField(..), DataResult)
import Dodo (Doc)
import Dodo as Dodo
import InteractiveData.Core.Types.DataAction (DataAction)

--------------------------------------------------------------------------------
--- Types
--------------------------------------------------------------------------------

type TreeMeta =
  { errored :: DataResult Unit
  , typeName :: String
  }

newtype DataTree srf msg = DataTree
  { view :: srf msg
  , children :: DataTreeChildren srf msg
  , actions :: Array (DataAction msg)
  , meta :: Maybe TreeMeta
  , text :: Maybe String
  }

data DataTreeChildren srf msg
  = Fields
      (Array (DataPathSegmentField /\ DataTree srf msg))
  | Case
      (String /\ DataTree srf msg)

-- | A trivial tree is
-- |   a) a tree with no children (leaf)
-- |   b) a tree with a single "field" child
-- |   c) a tree with a "case" child
digTrivialTrees
  :: forall srf msg
   . DataPath
  -> DataTree srf msg
  -> Array (DataPath /\ DataTree srf msg)
digTrivialTrees path tree@(DataTree { children }) = case children of
  Case (_ /\ (DataTree { meta: Just { typeName: "Arguments" }, children: Fields [] })) ->
    [ path /\ tree ]

  -- Case
  Case case_ ->
    let
      (k /\ subTree) = case_

      newPath :: DataPath
      newPath = path <> [ SegCase k ]
    in
      [ path /\ tree ] <> digTrivialTrees newPath subTree

  -- Singleton "Arguments"
  Fields [ SegStaticIndex ix /\ subTree ] ->
    let
      newPath :: DataPath
      newPath = path <> [ SegField $ SegStaticIndex ix ]
    in
      digTrivialTrees newPath subTree

  -- Leaf
  Fields [] -> [ path /\ tree ]

  -- Singleton static field
  Fields [ field@(SegStaticKey _ /\ _) ] ->
    let
      k /\ subTree = field

      newPath :: DataPath
      newPath = path <> [ SegField k ]
    in
      [ path /\ tree ] <> digTrivialTrees newPath subTree

  -- Singleton static index
  Fields [ field@(SegStaticIndex _ /\ _) ] ->
    let
      k /\ subTree = field

      newPath :: DataPath
      newPath = path <> [ SegField k ]
    in
      [ path /\ tree ] <> digTrivialTrees newPath subTree

  Fields _ -> [ path /\ tree ]

--------------------------------------------------------------------------------

hasNoChildren :: forall srf msg. DataTree srf msg -> Boolean
hasNoChildren (DataTree { children }) =
  case children of
    Fields fields -> Array.null fields
    Case _ -> false

mapMetadataAlongPath
  :: forall srf msg
   . DataPath
  -> DataTree srf msg
  -> Maybe (Array (DataPathSegment /\ TreeMeta))
mapMetadataAlongPath = loop []
  where
  loop
    :: Array (DataPathSegment /\ TreeMeta)
    -> Array DataPathSegment
    -> DataTree srf msg
    -> Maybe (Array (DataPathSegment /\ TreeMeta))
  loop accum path (DataTree { children }) =
    let
      unconsResult :: Maybe { head :: DataPathSegment, tail :: Array DataPathSegment }
      unconsResult = Array.uncons path
    in
      case { unconsResult, children } of
        { unconsResult: Nothing
        , children: _
        } ->
          Just accum

        { unconsResult: Just { head: SegCase casePath, tail }
        , children: Case (caseTree /\ tree@(DataTree { meta }))
        } ->
          if casePath == caseTree then do
            meta' <- meta
            loop (accum <> [ SegCase casePath /\ meta' ]) tail tree
          else
            Nothing

        { unconsResult: Just { head: SegField fieldPath, tail }
        , children: Fields fields
        } -> do
          _ /\ tree@(DataTree { meta }) <- Array.find (fst >>> (_ == fieldPath)) fields
          meta' <- meta
          loop (accum <> [ SegField fieldPath /\ meta' ]) tail tree

        _ -> Nothing

setChildren :: forall srf msg. DataTreeChildren srf msg -> DataTree srf msg -> DataTree srf msg
setChildren children = over DataTree _ { children = children }

--------------------------------------------------------------------------------
--- API
--------------------------------------------------------------------------------

find :: forall srf msg. DataPath -> DataTree srf msg -> Maybe (DataTree srf msg)
find path tree@(DataTree { children }) =
  case
    Array.uncons path,
    children
    of
    Nothing, _ ->
      Just tree

    Just { head: SegCase casePath, tail },
    Case (caseTree /\ tree')
      | casePath == caseTree ->
          find tail tree'

    Just { head: SegField fieldPath, tail },
    Fields fields -> do
      _ /\ tree' <- Array.find (fst >>> (_ == fieldPath)) fields
      find tail tree'

    _, _ -> Nothing

prettyPrint :: forall a srf msg. String -> DataTree srf msg -> Doc a
prettyPrint label (DataTree { children }) =
  Dodo.lines
    [ Dodo.text label
    , Dodo.indent (prettyPrintChildren children)
    ]

  where

  prettyPrintChildren :: DataTreeChildren srf msg -> Doc a
  prettyPrintChildren = case _ of
    Fields fields -> Dodo.lines (map (\(key /\ value) -> printItem (show key /\ value)) fields)
    Case case_ -> Dodo.lines [ printItem case_ ]

  printItem :: String /\ DataTree srf msg -> Doc a
  printItem (key /\ value) = Dodo.lines
    [ Dodo.text key
    , Dodo.indent (prettyPrint "" value)
    ]

--------------------------------------------------------------------------------
--- Instances
--------------------------------------------------------------------------------

derive instance Newtype (DataTree srf msg) _

derive instance Generic (DataTree srf msg) _

derive instance Functor srf => Functor (DataTreeChildren srf)
derive instance Functor srf => Functor (DataTree srf)

derive instance (Eq1 srf, Eq (srf msg), Eq msg) => Eq (DataTree srf msg)
derive instance (Eq1 srf, Eq (srf msg), Eq msg) => Eq (DataTreeChildren srf msg)

derive instance (Ord (srf msg), Ord1 srf, Ord msg) => Ord (DataTree srf msg)
derive instance (Ord (srf msg), Ord1 srf, Ord msg) => Ord (DataTreeChildren srf msg)

instance Show (DataTree srf msg) where
  show tree = "\n" <> (Dodo.print Dodo.plainText Dodo.twoSpaces $ prettyPrint "Root" tree) <> "\n"

