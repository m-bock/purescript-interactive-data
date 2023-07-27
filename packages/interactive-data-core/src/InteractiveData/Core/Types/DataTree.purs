module InteractiveData.Core.Types.DataTree
  ( DataTree(..)
  , DataTreeChildren(..)
  , TreeMeta
  , find
  , hasNoChildren
  , mapMetadataAlongPath
  , mkDataTree
  , setChildren
  ) where

import Prelude

import Data.Array as Array
import Data.Eq (class Eq1)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, over, un)
import Data.Ord (class Ord1)
import Data.Tuple (fst)
import Data.Tuple.Nested (type (/\), (/\))
import DataMVC.Types (DataPath, DataPathSegment(..), DataPathSegmentField, DataResult)
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
  }

data DataTreeChildren srf msg
  = Fields
      (Array (DataPathSegmentField /\ DataTree srf msg))
  | Case
      (String /\ DataTree srf msg)

--------------------------------------------------------------------------------

hasNoChildren :: forall srf msg. DataTree srf msg -> Boolean
hasNoChildren = un DataTree >>> _.children >>> case _ of
  Fields fields -> Array.null fields
  Case _ -> false

mkDataTree :: forall srf msg. { view :: srf msg, typeName :: String } -> DataTree srf msg
mkDataTree { view, typeName } = DataTree
  { view
  , children: Fields []
  , actions: []
  , meta: Nothing
  }

mapMetadataAlongPath
  :: forall srf msg
   . DataPath
  -> DataTree srf msg
  -> Maybe (Array (DataPathSegment /\ TreeMeta))
mapMetadataAlongPath = loop []
  where
  loop accum path (DataTree { children }) = case Array.uncons path, children of
    Nothing, _ ->
      Just accum

    Just { head: SegCase casePath, tail },
    Case (caseTree /\ tree@(DataTree { meta }))
      | casePath == caseTree -> do
          meta' <- meta
          loop (accum <> [ SegCase casePath /\ meta' ]) tail tree

    Just { head: SegField fieldPath, tail },
    Fields fields
      | (Just (_ /\ tree@(DataTree { meta }))) <- Array.find (fst >>> (_ == fieldPath)) fields -> do
          meta' <- meta
          loop (accum <> [ SegField fieldPath /\ meta' ]) tail tree

    _, _ -> Nothing

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
    Fields fields
      | (Just (_ /\ tree')) <- Array.find (fst >>> (_ == fieldPath)) fields ->
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

