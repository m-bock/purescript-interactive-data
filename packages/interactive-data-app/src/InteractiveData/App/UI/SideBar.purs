module InteractiveData.App.UI.SideBar
  ( ViewCfg
  , view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import InteractiveData.App.UI.Assets as UI.Assets

type ViewCfg :: (Type -> Type) -> Type -> Type
type ViewCfg html msg = { menu :: html msg }

view :: forall html msg. IDHtml html => ViewCfg html msg -> html msg
view { menu } = withCtx \{ showLogo } ->
  let
    el = styleElems
      "InteractiveData.App.UI.SideBar#view"
      { root: C.div
          /\ css
            """
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            overflow: auto;
            """
      , poweredBy: C.div
          /\ css
            """
            color: #999;
            padding: 0.5em;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items:   center;
            gap: 10px;
            stroke:#dfdfdf;
            margin-bottom: 15px;
            """
          /\
            [ declWith ":hover" $
                css
                  """
                  stroke: #30ffc4;
                  color: #30ffc4; 
                  """
            ]

      , logoText: "font-size: 10px"

      , logo:
          [ decl
              """
              width: 30px;
              height: 30px;
              """
          ]
      , link: C.a /\
          [ declWith ":link" [ "text-decoration : none" ]
          , declWith ":visited" [ "text-decoration : none" ]
          , declWith ":hover" [ "text-decoration : none" ]
          , declWith ":active" [ "text-decoration : none" ]
          ]
      }
  in
    el.root_
      [ menu
      , if showLogo then
          el.link [ C.href "https://github.com/thought2/purescript-interactive-data" ]
            [ el.poweredBy_
                [ el.logo_
                    [ UI.Assets.viewLogo ]
                , el.logoText_
                    [ C.span_ [ C.text "built with " ]
                    , C.span_
                        [ C.text "interactive-data" ]
                    ]
                ]
            ]
        else C.noHtml
      ]