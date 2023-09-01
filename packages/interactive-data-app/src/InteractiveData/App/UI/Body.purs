module InteractiveData.App.UI.Body
  ( ViewCfg
  , view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C

type ViewCfg (html :: Type -> Type) msg =
  { viewContent :: html msg
  }

view :: forall html msg. IDHtml html => ViewCfg html msg -> html msg
view { viewContent } =
  let
    el =
      { body: styleNode C.div unit
      , content: styleNode C.div
          [ "padding: 10px"
          , "padding-right: 15px"
          , "max-width: 600px"
          ]
      }
  in
    el.body []
      [ el.content []
          [ viewContent ]
      ]