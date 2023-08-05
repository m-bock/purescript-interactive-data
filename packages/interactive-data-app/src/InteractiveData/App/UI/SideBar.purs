module InteractiveData.App.UI.SideBar
  ( ViewCfg
  , view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as VD
import InteractiveData.App.UI.Assets as UI.Assets

type ViewCfg :: (Type -> Type) -> Type -> Type
type ViewCfg html msg = { menu :: html msg }

view :: forall html msg. IDHtml html => ViewCfg html msg -> html msg
view { menu } =
  let
    el =
      { root: styleNode VD.div
          """
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
          """
      , poweredBy: styleNode VD.div
          [ decl $ pure
              """
                font-size: 0.8em;
                color: #999;
                padding: 0.5em;
                text-align: center;
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 10px;
                stroke:#dfdfdf;
                margin-bottom: 10px;
              """
          , declWith ":hover" $ pure
              """
                stroke: #30ffc4;
                color: #30ffc4; 
              """
          ]

      , logo: styleNode VD.div
          [ decl $ pure
              """
                width: 50px;
                height: 50px;
              """
          ]
      , link: styleNode VD.a
          [ declWith ":link" [ "text-decoration : none" ]
          , declWith ":visited" [ "text-decoration : none" ]
          , declWith ":hover" [ "text-decoration : none" ]
          , declWith ":active" [ "text-decoration : none" ]
          ]
      }

    showBranding = false
  in
    el.root []
      [ menu
      , if showBranding then
          el.link [ VD.href "https://github.com/thought2/purescript-interactive-data" ]
            [ el.poweredBy []
                [ el.logo []
                    [ UI.Assets.viewLogo ]
                , VD.div []
                    [ VD.span_ [ VD.text "powered by " ]
                    , VD.span []
                        [ VD.text "interactive-data" ]
                    ]
                ]
            ]
        else VD.noHtml
      ]