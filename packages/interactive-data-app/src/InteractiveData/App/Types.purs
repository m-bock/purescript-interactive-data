module InteractiveData.App.Types
  ( InitError(..)
  ) where

import DataMVC.Types (DataPathSegment)

data InitError
  = ErrPathNotFound (Array DataPathSegment)
  | GlobalMetaNotFound
  | SumTreeNotFound
  | SelectedDataTreeNotFound
  | SelectedMetaNotFound