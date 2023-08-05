module Demo.Common.CompleteSample where

import InteractiveData (class IDHtml, DataUI, IDSurface)
import InteractiveData as ID

type Sample =
  { user ::
      { firstName :: String
      , lastName :: String
      , size :: Number
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
      , size: ID.number { min: 0.0, max: 100.0 }
      }
  , meta: ID.record_
      { description: ID.string_
      , headline: ID.string_
      }
  }
