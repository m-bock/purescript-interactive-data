module InteractiveData.Class.Defaults (module Export) where

import InteractiveData.Class.Defaults.Record
  ( class DefaultRecord
  , defaultRecord
  , class DefaultRecordPartial
  , defaultRecordPartial_
  ) as Export

import InteractiveData.Class.Defaults.Variant
  ( class DefaultVariant
  , defaultVariant
  ) as Export

import InteractiveData.Class.Defaults.Generic
  ( class DefaultGeneric
  , defaultGeneric_
  ) as Export
