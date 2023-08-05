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

  , RecordMsg
  , RecordState
  , record_
  ) as Export

import InteractiveData.Run
  ( getExtract
  , getUi
  ) as Export

import InteractiveData.Core
  ( IDSurface
  , class IDHtml
  ) as Export

import InteractiveData.Entry
  ( toApp
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
