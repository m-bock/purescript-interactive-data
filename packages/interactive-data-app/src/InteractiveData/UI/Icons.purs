module InteractiveData.App.UI.Icons
  ( breadCrumb
  ) where

import InteractiveData.Core.Prelude

import Data.String.NonEmpty as NES
import Data.String.NonEmpty.CodeUnits as Str
import InteractiveData.Core (class IDHtml)
import VirtualDOM as VD
import VirtualDOM.Styled (styleNode)

breadCrumb :: forall html msg. IDHtml html => html msg
breadCrumb = mkIcon '›'

mkIcon :: forall html msg. IDHtml html => Char -> html msg
mkIcon char =
  let
    el =
      { root: styleNode VD.div
          [ "font-size: 12px"
          , "display: flex"
          , "justify-content: center"
          , "align-items: center"
          , "width: 18px"
          , "height: 18px"
          , "cursor: default"
          ]
      , inner: styleNode VD.div ""
      }
  in
    el.root []
      [ el.inner []
          [ VD.text (NES.toString $ Str.singleton char) ]
      ]