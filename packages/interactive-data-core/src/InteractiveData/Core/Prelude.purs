module InteractiveData.Core.Prelude
  ( module Export
  , module Prelude
  ) where

import Prelude

import Data.Eq
  ( class Eq1
  , class EqRecord
  , eq1
  , eqRecord
  , notEq1
  ) as Export

import Data.Generic.Rep
  ( class Generic
  , Argument(..)
  , Constructor(..)
  , NoArguments(..)
  , NoConstructors
  , Product(..)
  , Sum(..)
  , from
  , repOf
  , to
  ) as Export

import Data.Maybe
  ( Maybe(..)
  , fromJust
  , fromMaybe
  , fromMaybe'
  , isJust
  , isNothing
  , maybe
  , maybe'
  , optional
  ) as Export

import Data.Newtype
  ( un
  , unwrap
  , wrap
  , class Newtype
  ) as Export

import Data.Ord
  ( class Ord1
  , class OrdRecord
  , abs
  , compare1
  , compareRecord
  , greaterThan
  , greaterThanOrEq
  , lessThan
  , lessThanOrEq
  , signum
  ) as Export

import Data.Identity
  ( Identity(..)
  ) as Export

import Data.Either
  ( Either(..)
  , blush
  , choose
  , either
  , fromLeft
  , fromLeft'
  , fromRight
  , fromRight'
  , hush
  , isLeft
  , isRight
  , note
  , note'
  ) as Export

import Type.Row
  ( class Cons
  , class Lacks
  , class Nub
  , class Union
  , type (+)
  , RowApply
  ) as Export

import Data.Tuple.Nested
  ( type (/\)
  , T10
  , T11
  , T2
  , T3
  , T4
  , T5
  , T6
  , T7
  , T8
  , T9
  , Tuple1
  , Tuple10
  , Tuple2
  , Tuple3
  , Tuple4
  , Tuple5
  , Tuple6
  , Tuple7
  , Tuple8
  , Tuple9
  , curry1
  , curry10
  , curry2
  , curry3
  , curry4
  , curry5
  , curry6
  , curry7
  , curry8
  , curry9
  , get1
  , get10
  , get2
  , get3
  , get4
  , get5
  , get6
  , get7
  , get8
  , get9
  , over1
  , over10
  , over2
  , over3
  , over4
  , over5
  , over6
  , over7
  , over8
  , over9
  , tuple1
  , tuple10
  , tuple2
  , tuple3
  , tuple4
  , tuple5
  , tuple6
  , tuple7
  , tuple8
  , tuple9
  , uncurry1
  , uncurry10
  , uncurry2
  , uncurry3
  , uncurry4
  , uncurry5
  , uncurry6
  , uncurry7
  , uncurry8
  , uncurry9
  , (/\)
  ) as Export

import Data.Show.Generic
  ( class GenericShow
  , class GenericShowArgs
  , genericShow
  , genericShow'
  , genericShowArgs
  ) as Export

import Data.These
  ( These(..)
  , assoc
  , both
  , fromThese
  , isBoth
  , isThat
  , isThis
  , maybeThese
  , swap
  , that
  , thatOrBoth
  , these
  , theseLeft
  , theseRight
  , this
  , thisOrBoth
  ) as Export

import Chameleon.Styled
  ( class IsStyle
  , class HtmlStyled
  , Anim
  , ClassName(..)
  , InlineStyle(..)
  , Style
  , StyleDecl
  , StyleMap
  , StyleT
  , anim
  , decl
  , declWith
  , registerStyleMap
  , runStyleT
  , styleKeyedLeaf
  , styleKeyedNode
  , styleLeaf
  , styleNode
  , toStyle
  , mergeDecl
  ) as Export

import Chameleon.Transformers.Ctx.Class
  ( class AskCtx
  , class Ctx
  , putCtx
  , setCtx
  , withCtx
  ) as Export

import InteractiveData.Core.Classes.OptArgs
  ( class OptArgs
  , class OptArgsMixed
  , NoConvert
  , getAllArgs
  , getAllArgsMixed
  ) as Export

import DataMVC.Types.DataError
  ( DataError(..)
  ) as Export

import DataMVC.Types
  ( DataErrorCase(..)
  , DataPath
  , DataPathSegment(..)
  , DataPathSegmentField(..)
  , DataResult
  , DataUI(..)
  , DataUICtx(..)
  , DataUiInterface(..)
  ) as Export

import InteractiveData.Core
  ( class IDHtml
  , DataAction(..)
  , DataTree(..)
  , DataTreeChildren(..)
  , IDOutMsg(..)
  , IDSurface(..)
  , IDSurfaceCtx
  , IDViewCtx
  , PathInContext
  , TreeMeta
  , ViewMode(..)
  ) as Export

import InteractiveData.Core.Util.RecordProjection
  ( pick
  ) as Export

import Chameleon.Styled
  ( styleElemsXstyleElems"InteractiveData.Core.Prelude"
XstyleElemsXstyleElems"InteractiveData.Core.Prelude"
"InteractiveData.Core.Prelude"

  ) as Export