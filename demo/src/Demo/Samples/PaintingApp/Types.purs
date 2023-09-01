module Demo.Samples.PaintingApp.Types
  ( Image
  , Meta
  , Painting
  , Shape(..)
  , USD(..)
  , printUSD
  ) where

import Prelude

import Chameleon (class Html)
import Data.Argonaut (class EncodeJson)
import Data.Argonaut.Encode.Generic (genericEncodeJson)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)
import Data.Show.Generic (genericShow)
import Demo.Samples.PaintingApp.ArchiveID (ArchiveID)
import Demo.Samples.PaintingApp.Color (Color)
import InteractiveData (class IDDataUI, IntMsg, IntState, dataUi, newtype_)
import InteractiveData as ID
import InteractiveData.Class (Tok(..))
import InteractiveData.Class.Defaults (class DefaultGeneric, defaultGeneric_)
import Type.Proxy (Proxy(..))

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
  Html html =>
  IDDataUI html fm fs IntMsg IntState USD
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
  IDDataUI html fm fs msg sta Shape
  where
  dataUi = defaultGeneric_ @"Circle" Tok Proxy "Shape"