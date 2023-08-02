module InteractiveData.Core.Classes.OptArgs
  ( NoConvert
  , class OptArgs
  , getAllArgs
  , class OptArgsMixed
  , getAllArgsMixed
  ) where

import Prelude

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults, convertOptionsWithDefaults)

data NoConvert = NoConvert

instance ConvertOption NoConvert sym a a where
  convertOption _ _ = identity

class OptArgs all given where
  getAllArgs :: all -> given -> all

instance
  ( ConvertOptionsWithDefaults NoConvert all given all
  ) =>
  OptArgs all given
  where
  getAllArgs defaults given = convertOptionsWithDefaults NoConvert defaults given

--------------------------------------------------------------------------------

---
class OptArgsMixed all defaults given | all -> defaults given where
  getAllArgsMixed :: Record defaults -> given -> all

instance
  ( ConvertOptionsWithDefaults NoConvert (Record defaults) given all
  ) =>
  OptArgsMixed all defaults given
  where
  getAllArgsMixed defaults given = convertOptionsWithDefaults NoConvert defaults given

