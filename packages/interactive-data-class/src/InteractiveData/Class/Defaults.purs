module InteractiveData.Class.Defaults (module Export) where

import InteractiveData.Class.Defaults.Record
  ( class DefaultRecord
  , defaultRecord
  , class DefaultRecordPartial
  , defaultRecordPartial
  ) as Export

import InteractiveData.Class.Defaults.Variant
  ( class DefaultVariant
  , defaultVariant
  , class DefaultVariantPartial
  ) as Export

import InteractiveData.Class.Defaults.Generic
  ( class DefaultGeneric
  , defaultGeneric_
  , class DefaultGenericPartial
  , defaultGenericPartial_
  ) as Export
