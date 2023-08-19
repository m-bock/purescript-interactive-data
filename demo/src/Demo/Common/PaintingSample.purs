module Demo.Common.PaintingSample
  ( Color
  , Image
  , Meta
  , Painting
  , Shape(..)
  , USD(..)
  , printUSD
  ) where

import Prelude

import Data.Argonaut (class EncodeJson)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)
import Demo.Common.Features.Refinement.ArchiveID (ArchiveID)
import InteractiveData
  ( class IDDataUI
  , class IDHtml
  , IDSurface
  , IntMsg
  , IntState
  , NumberMsg
  , NumberState
  , dataUi
  , newtype_
  )

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

data Color = Color { red :: Int, green :: Int, blue :: Int }

newtype USD = USD Int

printUSD :: USD -> String
printUSD (USD n) = "$" <> show n

derive instance Newtype USD _

instance
  IDHtml html =>
  IDDataUI (IDSurface html) fm fs IntMsg IntState USD
  where
  dataUi = newtype_ dataUi

derive newtype instance EncodeJson USD

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
  --   , frame :: Number
  --   , background :: Color
  --   , shapes ::
  --       Array
  --         { shape :: Shape
  --         , color :: Color
  --         , outline :: Boolean
  --         }
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

