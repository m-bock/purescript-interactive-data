module Demo.Common.CompleteSample
  ( Sample
  , sampleDataUi
  ) where

import Prelude

import Data.Maybe (Maybe(..))
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
  { user:
      ID.record
        { text: Just "A sample user"
        }
        { firstName: ID.string { text: Just "First name" }
        , lastName: ID.string_
        , size: ID.number
            { min: 0.0
            , max: 100.0
            }
        , userId: userId_
        , age: ID.int
            { text: Just "The Age"
            , min: 0
            , max: 150
            }
        }
  , meta: ID.record
      { text: Just "Some sample meta data"
      }
      { description: ID.string_
      , headline: ID.string_
      , info:
          ID.newtype_ $
            ID.variant @"name"
              { text: Just "Pick one!" }
              { name: ID.string
                  { text: Just "What's your name?"
                  }
              , age: ID.int
                  { text: Just "How old are you?"
                  , min: 0
                  , max: 150
                  }
              }
      }
  , theme: ID.record
      { text: Just "A sample theme to configure"
      }
      { backgroundColor: color {}
      , foregroundColor: color {}
      , textColor: color {}
      }
  }
