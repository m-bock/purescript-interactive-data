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
    el = styleElems "InteractiveData.App.UI.Body#view"
      { root: C.div
      , content: C.div /\
          [ "padding: 5px"
          , "padding-right: 15px"
          , "padding-left: 15px"
          , "max-width: 800px"
          ]
      }
  in
    el.root_
      [ el.content_
          [ viewContent ]
      ]