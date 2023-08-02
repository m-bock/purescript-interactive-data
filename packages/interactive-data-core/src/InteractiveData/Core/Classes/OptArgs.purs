module InteractiveData.Core.Classes.OptArgs
  ( NoConvert
  , class OptArgs
  , class MixedOptArgs
  , getAllArgs
  , mixedGetAllArgs
  )
  where

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

class MixedOptArgs all defaults given | all -> defaults given  where
  mixedGetAllArgs :: Record defaults -> given -> all

instance
  ( ConvertOptionsWithDefaults NoConvert (Record defaults) given all
  ) =>
  MixedOptArgs all defaults given
  where
  mixedGetAllArgs defaults given = convertOptionsWithDefaults NoConvert defaults given

