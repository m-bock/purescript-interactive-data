module Demo.Common.Features.CustomDataUI.Color
  ( Color
  ) where

import Prelude

import Data.Argonaut (class DecodeJson, class EncodeJson)

newtype Color = Color
  { red :: Int
  , green :: Int
  , blue :: Int
  }

derive newtype instance EncodeJson Color
derive newtype instance DecodeJson Color
derive newtype instance Show Color
