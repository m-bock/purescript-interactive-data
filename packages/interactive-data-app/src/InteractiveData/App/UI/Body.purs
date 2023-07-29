module InteractiveData.App.UI.Body
  ( ViewBodyCfg
  , viewBody
  ) where

import InteractiveData.Core.Prelude

import InteractiveData.Core (class IDHtml)
import VirtualDOM as VD

type ViewBodyCfg (html :: Type -> Type) msg =
  { viewContent :: html msg
  }

viewBody :: forall html msg. IDHtml html => ViewBodyCfg html msg -> html msg
viewBody { viewContent } =
  let
    el =
      { body: styleNode VD.div unit
      , content: styleNode VD.div
          [ "padding: 10px"
          , "padding-left: 20px"
          ]
      }
  in
    el.body []
      [ el.content []
          [ viewContent ]
      ]