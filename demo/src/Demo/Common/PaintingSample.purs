module Demo.Common.PaintingSample
  ( Image
  , ImageElement
  , Meta
  , Painting
  , Shape(..)
  , USD(..)
  , paintingDataUi
  , printUSD
  ) where

import Prelude

import Data.Argonaut (class EncodeJson)
import Data.Argonaut.Encode.Generic (genericEncodeJson)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Show.Generic (genericShow)
import Demo.Common.Features.CustomDataUI.Color (Color, color)
import Demo.Common.Features.Refinement.ArchiveID (ArchiveID, archiveID)
import InteractiveData (class IDDataUI, class IDHtml, DataUI, DataUI', IDSurface, IntMsg, IntState, dataUi, newtype_)
import InteractiveData as ID
import InteractiveData.Class (Tok(..))
import InteractiveData.Class.Defaults (class DefaultGeneric, defaultGeneric_)
import Type.Proxy (Proxy(..))

{-
 - [x] String
 - [x] Number
 - [x] Boolean
 - [x] Int
 - [x] Array
 - [ ] Variant
 - [x] Record
 - [x] Maybe
 - [ ] Either
 - [ ] Newtype
 - [ ] Tuple
 - [x] Refinement
 - [x] Custom ADT
 - [x] Custom type
 - [ ] Json
-}

--------------------------------------------------------------------------------
--- Types
--------------------------------------------------------------------------------

newtype USD = USD Int

type Meta =
  { title :: Maybe String
  , author :: Maybe String
  , year :: Maybe Int
  , archiveId :: ArchiveID
  , keywords :: Array String
  , price :: USD
  }

type Image =
  { width :: Number
  , height :: Number
  , frame :: Number
  , background :: Color
  , elements :: Array ImageElement
  }

type ImageElement =
  { shape :: Shape
  , color :: Color
  , outline :: Boolean
  }

type Painting =
  { meta :: Meta
  , image :: Image
  }

data Shape
  = Rect
      { x :: Number
      , y :: Number
      , width :: Number
      , height :: Number
      }
  | Circle
      { x :: Number
      , y :: Number
      , radius :: Number
      }
  | Line
      { xStart :: Number
      , yStart :: Number
      , xEnd :: Number
      , yEnd :: Number
      }

--------------------------------------------------------------------------------
--- Data UI
--------------------------------------------------------------------------------

paintingDataUi :: DataUI' _ _ Painting
paintingDataUi = ID.record_
  { meta: ID.recordPartial
      { text: Just "Contains meta data about a painting"
      }
      { title: ID.maybe
          { text: Just "The title of the Painting, if existing"
          }
          { "Just": ID.string_
          , "Nothing": unit
          }
      , author: ID.maybe
          { text: Just "The author of the Painting, if known"
          }
          { "Just": ID.string_
          , "Nothing": unit
          }
      , year: ID.maybe
          { text: Just "The year the painting was created"
          }
          { "Just": ID.int
              { min: 1900
              , max: 3000
              }
          , "Nothing": unit
          }
      , archiveId: archiveID
          { text: Just "The ID of the painting in the archive. Only lowercase letters."
          }
      , keywords: ID.array
          { text: Just "A list of keywords describing the painting"
          }
          ID.string_
      , price: ID.newtype_ $ ID.int
          { min: 1900
          , max: 3000
          , text: Just "The price for the next auction"
          }
      }
  , image: ID.recordPartial
      { text: Just "The actual image data: Shapes and Colors"
      }
      { height: ID.number
          { text: Just "The height of the image"
          , min: 0.0
          , max: 100.0
          }
      , width: ID.number
          { text: Just "The width of the image"
          , min: 0.0
          , max: 100.0
          }
      , frame: ID.number
          { text: Just "The width of the frame around the image"
          , min: 0.0
          , max: 20.0
          }
      , background: color
          { text: Just "The background color of the image" }
      }
  }

shape
  :: forall opt html fm fs datauis msg sta
   . ID.GenericDataUI opt html fm fs "Foo" datauis msg sta Shape
  => opt
  -> { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta Shape
shape = ID.generic
  { typeName: "Shape"
  }

--------------------------------------------------------------------------------
--- Utils
--------------------------------------------------------------------------------

printUSD :: USD -> String
printUSD (USD n) = "$" <> show n

--------------------------------------------------------------------------------
--- Instances
--------------------------------------------------------------------------------

--- USD

derive instance Newtype USD _

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs IntMsg IntState USD
  where
  dataUi = newtype_ dataUi

derive newtype instance EncodeJson USD

--- Shape

derive instance Generic Shape _

instance Show Shape where
  show = genericShow

instance EncodeJson Shape where
  encodeJson = genericEncodeJson

instance
  ( DefaultGeneric "Circle" Tok html fm fs msg sta Shape
  ) =>
  IDDataUI (IDSurface html) fm fs msg sta Shape
  where
  dataUi = defaultGeneric_ @"Circle" Tok Proxy "Shape"