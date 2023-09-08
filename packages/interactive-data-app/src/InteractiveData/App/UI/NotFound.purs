module InteractiveData.App.UI.NotFound
  ( ViewCfg
  , view
  ) where

import InteractiveData.Core.Prelude

import Data.String as Str
import InteractiveData.App.UI.Assets as UI.Assets
import Chameleon as C

type ViewCfg msg =
  { onBackToHome :: msg
  , path :: Array String
  , reason :: String
  }

view :: forall html msg. IDHtml html => ViewCfg msg -> html msg
view { onBackToHome, path, reason } =
  let
    el = styleElems "InteractiveData.App.UI.NotFound#view"
      { notfound: C.div /\
          [ "display: flex"
          , "flex-direction: column"
          , "justify-content: center"
          , "align-items: center"
          , "height: 100%"
          , "gap: 20px"
          ]
      , text: C.div /\
          [ "font-size: 12px"
          , "cursor: pointer"
          ]
      , icon: C.div
          /\
            [ "width: 100px"
            , "animation: $anim 400ms ease-out"
            ]
          /\ anim "anim"
            [ "0%" /\
                [ "transform: rotate(-360deg) scale(0)" ]
            , "80%" /\
                [ "transform: rotate(10deg) scale(1)" ]
            , "100%" /\
                [ "transform: rotate(0deg) scale(1)" ]
            ]
      , headline: C.div /\
          [ "font-size: 20px" ]
      , path: C.span /\
          [ "font-weight: bold" ]
      }
  in
    el.notfound_
      [ el.icon_
          [ UI.Assets.viewPageNotFound
          ]
      , el.headline_
          [ C.text "Not Found: "
          , el.path_ [ C.text ("/" <> printPath path) ]
          , C.text $ " (" <> reason <> ")"
          ]
      , el.text [ C.onClick onBackToHome ]
          [ C.text "Back to Home"
          ]
      ]

printPath :: Array String -> String
printPath path =
  Str.joinWith "/" path