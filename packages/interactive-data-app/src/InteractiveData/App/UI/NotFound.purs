module InteractiveData.App.UI.NotFound
  ( ViewNotFoundCfg
  , viewNotFound
  ) where

import InteractiveData.Core.Prelude

import Data.String as Str
import InteractiveData.App.UI.Assets as UI.Assets
import Chameleon as VD

type ViewNotFoundCfg msg =
  { onBackToHome :: msg
  , path :: Array String
  }

viewNotFound :: forall html msg. IDHtml html => ViewNotFoundCfg msg -> html msg
viewNotFound { onBackToHome, path } =
  let
    el =

      { notfound: styleNode VD.div
          [ "display: flex"
          , "flex-direction: column"
          , "justify-content: center"
          , "align-items: center"
          , "height: 100%"
          , "gap: 20px"
          ]
      , text: styleNode VD.div
          [ "font-size: 12px"
          , "cursor: pointer"
          ]
      , icon: styleNode VD.div
          $ decl
              [ "width: 100px"
              , "animation: $anim 400ms ease-out"
              ]
          /\
            anim "anim"
              [ "0%" /\
                  [ "transform: rotate(-360deg) scale(0)" ]
              , "80%" /\
                  [ "transform: rotate(10deg) scale(1)" ]
              , "100%" /\
                  [ "transform: rotate(0deg) scale(1)" ]
              ]
      , headline: styleNode VD.div
          [ "font-size: 20px" ]
      , path: styleNode VD.span
          [ "font-weight: bold" ]
      }
  in
    el.notfound []
      [ el.icon []
          [ UI.Assets.viewPageNotFound
          ]
      , el.headline []
          [ VD.text "Not Found: "
          , el.path [] [ VD.text (printPath path) ]
          ]
      , el.text [ VD.onClick onBackToHome ]
          [ VD.text "Back to Home"
          ]
      ]

printPath :: Array String -> String
printPath path =
  Str.joinWith "/" path