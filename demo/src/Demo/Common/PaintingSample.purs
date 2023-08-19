module Demo.Common.PaintingSample
  ( ArchiveID(..)
  , Color
  , Image
  , Meta
  , Painting
  , Shape(..)
  , USD(..)
  ) where

import Data.Maybe (Maybe)

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

newtype ArchiveID = ArchiveID String

newtype USD = USD Number

type Meta =
  { title :: Maybe String
  , author :: Maybe String
  --   , year :: Maybe Int
  --   , archiveId :: ArchiveID
  --   , keywords :: Array String
  --   , price :: USD
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
      { x1 :: Number
      , y1 :: Number
      , x2 :: Number
      , y2 :: Number
      }

