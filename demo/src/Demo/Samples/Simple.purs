module Demo.Samples.Simple where

import Data.Maybe (Maybe(..))
import InteractiveData (class IDHtml, DataUI, IDSurface)
import InteractiveData as ID
import InteractiveData.Entry (InteractiveDataApp)
import Chameleon (class Html)

type Sample =
  { user ::
      { firstName :: String
      , lastName :: String
      }
  , meta ::
      { description :: String
      , headline :: String
      }
  }

sampleDataUi
  :: forall html
   . IDHtml html
  => DataUI (IDSurface html) _ _ _ _ Sample
sampleDataUi = ID.record_
  { user: ID.record_
      { firstName: ID.string_
      , lastName: ID.string_
      }
  , meta: ID.record_
      { description: ID.string_
      , headline: ID.string_
      }
  }

sampleApp :: forall html. Html html => InteractiveDataApp html _ _ Sample
sampleApp =
  ID.toApp
    { name: "Sample"
    , initData: Nothing
    , fullscreen: true
    }
    sampleDataUi