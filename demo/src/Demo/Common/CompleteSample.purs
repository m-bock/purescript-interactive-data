module Demo.Common.CompleteSample
  ( CustomADT(..)
  , Sample
  , sampleDataUi
  ) where

import Prelude

import Data.Argonaut (class EncodeJson)
import Data.Argonaut.Encode.Generic (genericEncodeJson)
import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Show.Generic (genericShow)
import Data.Tuple (Tuple)
import Demo.Common.Features.Refinement.UserID (UserID, userId_)
import Demo.Common.VariantJ (VariantJ)
import InteractiveData (class IDHtml, DataUI, IDSurface)
import InteractiveData as ID

type Sample =
  { user ::
      { firstName :: String
      , lastName :: String
      , size :: Number
      , userId1 :: UserID
      , userId2 :: UserID
      , age :: Int
      , description :: Maybe String
      , nestedMaybe :: Maybe (Maybe String)
      , custom :: CustomADT
      , tuple :: Tuple String Int
      , result :: Either String Int
      , switch :: Boolean
      , items :: Array { x :: Int, y :: Int }
      , items2 :: Array { x :: Int, y :: Int }
      , items3 :: Array String
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
      { coordinate :: { x :: Int, y :: Int }
      , item :: Maybe Int
      , size :: VariantJ (width :: Int, height :: Int, depth :: Int)
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
        , userId1: userId_
        , userId2: userId_
        , age: ID.int
            { text: Just "The Age"
            , min: 0
            , max: 150
            }
        , description: ID.mkMaybe_
            { "Just": ID.string_
            , "Nothing": unit
            }
        , nestedMaybe: ID.mkMaybe_
            { "Just": ID.mkMaybe_
                { "Just": ID.string_
                , "Nothing": unit
                }
            , "Nothing": unit
            }
        , custom: customADT {}
            { "Foo": ID.int_
            , "Bar": ID.string_
            , "Baz": ID.number_
            }
        , tuple: ID.tuple_ ID.string_ ID.int_
        , result: ID.either_ ID.string_ ID.int_
        , switch: ID.boolean { text: Just "Switch it!" }
        , items: ID.json
            { init: []
            , typeName: "Array { x :: Int, y :: Int }"
            , text: Just "For types that don't have a Data UI implementation (yet) one can use the generic Json Data UI"
            }
        , items2: ID.array_ ID.dataUi
        , items3: ID.array_ ID.string_
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
      { coordinate: ID.dataUi
      , item: ID.dataUi
      , size: ID.newtype_ $ ID.variantPartial_ @"width"
          { width: ID.int { min: 0 }
          }
      }
  }

--------------------------------------------------------------------------------
--- Custom ADT
--------------------------------------------------------------------------------

data CustomADT
  = Foo Int
  | Bar String
  | Baz Number

derive instance Generic CustomADT _

instance Show CustomADT where
  show = genericShow

instance EncodeJson CustomADT where
  encodeJson = genericEncodeJson

customADT
  :: forall opt html fm fs datauis msg sta
   . ID.GenericDataUI opt html fm fs "Foo" datauis msg sta CustomADT
  => opt
  -> { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta CustomADT
customADT = ID.generic
  { typeName: "CustomADT"
  }

--------------------------------------------------------------------------------