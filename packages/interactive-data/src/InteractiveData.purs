module InteractiveData (module Export) where

import InteractiveData.DataUIs
  ( StringMsg
  , StringState
  , CfgString
  , string
  , string_

  , ArrayMsg
  , ArrayState
  , array
  , array_

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
  , generic_
  , class GenericDataUI
  , Product
  , TypeName(..)
  , type (~)
  , (~)

  , newtype_

  , maybe_
  , maybe
  , mkMaybe
  , mkMaybe_
  , either_
  , either
  , tuple_
  , tuple
  , unit
  , unit_

  , JsonMsg
  , JsonState
  , json

  , TrivialCfg
  , mkTrivialDataUi
  ) as Export

import InteractiveData.Run
  ( getExtract
  , getUi
  ) as Export

import InteractiveData.Core.Types.IDHtmlT
  ( IDHtmlT
  ) as Export

import InteractiveData.Core
  ( IDSurface
  , class IDHtml
  , DataAction(..)
  ) as Export

import InteractiveData.Core.Classes.OptArgs
  ( class OptArgs
  ) as Export

import InteractiveData.Class
  ( class IDDataUI
  , dataUi
  ) as Export

import InteractiveData.Class.Partial
  ( recordPartial_
  , recordPartial
  , variantPartial_
  , genericPartial_
  ) as Export

import InteractiveData.Entry
  ( toApp
  , mkDataError
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

import InteractiveData.App
  ( WrapMsg
  , WrapState
  , AppMsg
  , AppState
  ) as Export

