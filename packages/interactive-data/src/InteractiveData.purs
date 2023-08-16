module InteractiveData (module Export) where

import InteractiveData.DataUIs
  ( StringMsg
  , StringState
  , string
  , string_

  , NumberMsg
  , NumberState
  , number
  , number_

  , IntMsg
  , IntState
  , int
  , int_

  , BooleanMsg
  , BooleanState
  , boolean
  , boolean_

  , RecordMsg
  , RecordState
  , record
  , record_

  , VariantMsg
  , VariantState
  , variant
  , variant_

  , generic
  , class GenericDataUI
  , Product
  , type (~)
  , (~)

  , newtype_

  , maybe_
  , either_
  , tuple_

  , JsonMsg
  , JsonState
  , json
  ) as Export

import InteractiveData.Run
  ( getExtract
  , getUi
  ) as Export

import InteractiveData.Core
  ( IDSurface
  , class IDHtml
  ) as Export

import InteractiveData.Class
  ( class IDDataUI
  , dataUi
  ) as Export

import InteractiveData.Class.Partial
  ( recordPartial_
  , variantPartial_
  , genericPartial_
  ) as Export

import InteractiveData.Entry
  ( toApp
  , DataUI'
  ) as Export

import DataMVC.Types
  ( DataPath
  , DataPathSegment(..)
  , DataPathSegmentField(..)
  , DataUI(..)
  , DataUICtx(..)
  , DataUiInterface(..)
  ) as Export

import DataMVC.Types.DataUI
  ( refineDataUi
  ) as Export

import DataMVC.Types.DataError
  ( DataError(..)
  , DataErrorCase(..)
  , DataResult
  , scopeError
  , scopeErrors
  , scopeOpt
  ) as Export
