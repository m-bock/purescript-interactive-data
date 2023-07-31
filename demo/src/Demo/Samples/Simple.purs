module Demo.Samples.Simple where

import Prelude

import Data.Maybe (Maybe(..))
import InteractiveData (class IDHtml, DataUI, IDSurface)
import InteractiveData as ID
import InteractiveData.Entry (InteractiveDataApp)
import Chameleon (class Html)

type Sample =
  { firstName :: String
  , lastName :: String
  }

sampleDataUi
  :: forall html
   . IDHtml html
  => DataUI (IDSurface html) _ _ _ _ Sample
sampleDataUi =
  ID.record_
    { firstName: ID.string_
    , lastName: ID.string_
    }

sampleApp :: forall html. Html html => InteractiveDataApp html _ _ Sample
sampleApp =
  ID.toApp
    { name: "Sample"
    , initData: Nothing
    , fullscreen: true
    }
    sampleDataUi