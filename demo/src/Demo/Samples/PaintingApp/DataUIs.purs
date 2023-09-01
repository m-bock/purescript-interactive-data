module Demo.Samples.PaintingApp.DataUIs
  ( imageDataUi
  , metaDataUi
  , paintingDataUi
  , shape
  , shapeDataUi
  ) where

import Prelude

import Chameleon (class Html)
import Data.Maybe (Maybe(..))
import Demo.Samples.PaintingApp.ArchiveID (archiveID)
import Demo.Samples.PaintingApp.Color (color)
import Demo.Samples.PaintingApp.Types (Image, Painting, Shape, Meta)
import InteractiveData (DataUI, DataUI', IDHtmlT, IDSurface)
import InteractiveData as ID

metaDataUi :: forall html. Html html => DataUI (IDSurface (IDHtmlT html)) _ _ _ _ Meta
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

shapeDataUi :: forall html. Html html => DataUI' html _ _ Shape
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

imageDataUi :: forall html. Html html => DataUI' html _ _ Image
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

paintingDataUi :: forall html. Html html => DataUI' html _ _ Painting
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