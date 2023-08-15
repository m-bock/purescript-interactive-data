module InteractiveData.Class.Defaults.Generic where

import DataMVC.Types (DataUI)
import InteractiveData.Core (IDSurface)

class
  DefaultVariant
    (token :: Type)
    (html :: Type -> Type)
    (fm :: Type -> Type)
    (fs :: Type -> Type)
    (msg :: Type)
    (sta :: Type)
    (typ :: Type)
  where
  defaultGeneric :: token -> DataUI (IDSurface html) fm fs msg sta typ
