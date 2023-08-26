module Demo.Samples.PaintingApp.Types
  ( Image
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
import Demo.Samples.PaintingApp.ArchiveID (ArchiveID, archiveID)
import Demo.Samples.PaintingApp.Color (Color, color)
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
  , shapes :: Array Shape
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
      , rotation :: Number
      , color :: Color
      , outline :: Boolean
      }
  | Circle
      { x :: Number
      , y :: Number
      , radius :: Number
      , color :: Color
      , outline :: Boolean
      }
  | Triangle
      { x :: Number
      , y :: Number
      , radius :: Number
      , rotation :: Number
      , color :: Color
      , outline :: Boolean
      }

--------------------------------------------------------------------------------
--- Data UI
--------------------------------------------------------------------------------
metaDataUi :: forall html. IDHtml html => DataUI (IDSurface html) _ _ _ _ Meta
metaDataUi = ID.recordPartial
  { text: Just "Contains meta data about a painting"
  }
  { title: ID.maybe
      { text: Just "The title of the Painting, if existing"
      }
      ID.string_
  , author: ID.maybe
      { text: Just "The author of the Painting, if known"
      }
      ID.string_
  , year: ID.maybe
      { text: Just "The year the painting was created"
      }
      ( ID.int
          { min: 1900
          , max: 3000
          }
      )
  , archiveId: archiveID
      { text: Just "The ID of the painting in the archive. Only lowercase letters."
      }
  , keywords: ID.array
      { text: Just "A list of keywords describing the painting"
      }
      ID.string_
  , price: ID.newtype_ (ID.TypeName "USD") $ ID.int
      { min: 0
      , max: 1000
      , text: Just "The price for the next auction"
      }
  }

shapeDataUi :: DataUI' _ _ Shape
shapeDataUi = shape
  { text: Just "The shape of the element"
  }
  { "Rect": ID.record
      { text: Just "A rectangle"
      }
      { x: ID.number
          { text: Just "The x coordinate of the top left corner"
          , min: 0.0
          , max: 100.0
          , init: Just 40.0
          }
      , y: ID.number
          { text: Just "The y coordinate of the top left corner"
          , min: 0.0
          , max: 100.0
          , init: Just 40.0
          }
      , width: ID.number
          { text: Just "The width of the rectangle"
          , min: 0.0
          , max: 100.0
          , init: Just 20.0
          }
      , height: ID.number
          { text: Just "The height of the rectangle"
          , min: 0.0
          , max: 100.0
          , init: Just 20.0
          }
      , rotation: ID.number
          { text: Just "The rotation angle of the rectangle"
          , min: 0.0
          , max: 360.0
          , init: Just 0.0
          }
      , outline: ID.boolean
          { text: Just "Whether the shape should be outlined"
          }
      , color: color
          { text: Just "The fill color of the shape"
          }
      }
  , "Circle": ID.record
      { text: Just "A circle"
      }
      { x: ID.number
          { text: Just "The x coordinate of the center"
          , min: 0.0
          , max: 100.0
          , init: Just 50.0
          }
      , y: ID.number
          { text: Just "The y coordinate of the center"
          , min: 0.0
          , max: 100.0
          , init: Just 50.0
          }
      , radius: ID.number
          { text: Just "The radius of the circle"
          , min: 0.0
          , max: 100.0
          , init: Just 10.0
          }
      , outline: ID.boolean
          { text: Just "Whether the shape should be outlined"
          }
      , color: color
          { text: Just "The fill color of the shape"
          }
      }
  , "Triangle": ID.record
      { text: Just "A triangle"
      }
      { x: ID.number
          { text: Just "The x coordinate of the center"
          , min: 0.0
          , max: 100.0
          , init: Just 50.0
          }
      , y: ID.number
          { text: Just "The y coordinate of the center"
          , min: 0.0
          , max: 100.0
          , init: Just 50.0
          }
      , radius: ID.number
          { text: Just "The radius of the triangle"
          , min: 0.0
          , max: 100.0
          , init: Just 10.0
          }
      , rotation: ID.number
          { text: Just "The rotation angle of the triangle"
          , min: 0.0
          , max: 360.0
          , init: Just 0.0
          }
      , outline: ID.boolean
          { text: Just "Whether the shape should be outlined"
          }
      , color: color
          { text: Just "The fill color of the shape"
          }
      }
  }

imageDataUi :: DataUI' _ _ Image
imageDataUi = ID.record
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
  , shapes: ID.array
      { text: Just "The graphical elements of the image"
      }
      shapeDataUi
  }

paintingDataUi :: DataUI' _ _ Painting
paintingDataUi = ID.record_
  { meta: metaDataUi
  , image: imageDataUi
  }

shape
  :: forall opt html datauis fm fs msg sta
   . ID.GenericDataUI "Circle" opt html datauis fm fs msg sta Shape
  => opt
  -> { | datauis }
  -> DataUI (IDSurface html) fm fs msg sta Shape
shape = ID.generic (ID.TypeName "Shape")

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
  dataUi = newtype_ (ID.TypeName "USD") dataUi

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