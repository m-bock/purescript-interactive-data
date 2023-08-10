module Demo.Common.CompleteSample where

import Prelude

import Demo.Common.Features.CustomDataUI.Color (Color, color)
import Demo.Common.Features.Refinement.UserID (UserID, userId_)
import Demo.Common.VariantJ (VariantJ)
import InteractiveData (class IDHtml, DataUI, IDSurface)
import InteractiveData as ID

type Sample =
  { user ::
      { firstName :: String
      , lastName :: String
      , size :: Number
      , userId :: UserID
      , age :: Int
      }
  , meta ::
      { description :: String
      , headline :: String
      , info ::
          VariantJ
            ( name :: String
            , age :: Int
            )
      }
  , theme ::
      { backgroundColor :: Color
      , foregroundColor :: Color
      , textColor :: Color
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
      , size: ID.number
          { min: 0.0
          , max: 100.0
          }
      , userId: userId_
      , age: ID.int
          { min: 0
          , max: 150
          }
      }
  , meta: ID.record_
      { description: ID.string_
      , headline: ID.string_
      , info:
          ID.newtype_ $
            ID.variant_ @"name"
              { name: ID.string_
              , age: ID.int { min: 0, max: 150 }
              }
      }
  , theme: ID.record_
      { backgroundColor: color {}
      , foregroundColor: color {}
      , textColor: color {}
      }
  }
