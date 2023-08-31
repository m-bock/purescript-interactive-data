module Landing.App where

import Prelude

import Chameleon as C
import Chameleon.Styled (class HtmlStyled, decl, declWith, styleNode)
import Data.Array (intersperse)
import Landing.App.LogoAnim as UILogo

view :: forall html msg. HtmlStyled html => html msg
view =
  let
    el =
      { root: styleNode C.div
          [ "display: grid"
          , "height: 100%"
          , "align-items: center"
          ]
      , content: styleNode C.div
          [ "display: flex"
          , "flex-direction: column"
          , "font-family: sans-serif"
          ]
      , logo: styleNode C.div
          [ "margin: auto"
          , "margin-bottom: 20px"
          , "stroke: #30FFC4"
          , "width: 100px"
          ]
      , caption: styleNode C.div
          [ "margin: auto"
          , "font-size: 30px"
          , "font-weight: bold"
          , "margin-bottom: 10px"
          ]
      , subCaption: styleNode C.div
          [ "margin: auto"
          , "margin-bottom: 20px"
          ]
      , links: styleNode C.div
          [ "margin: auto"
          ]
      , link: styleNode C.a
          [ declWith ":link" [ "text-decoration : none" ]
          , declWith ":visited" [ "text-decoration : none" ]
          , declWith ":hover" [ "text-decoration : none" ]
          , declWith ":active" [ "text-decoration : none" ]
          , decl
              [ "color : #1f94ff"
              , "font-size : 12px"
              , "font-family : sans-serif"
              ]
          ]
      }
  in
    el.root []
      [ el.content []
          [ el.logo []
              [ UILogo.view
              ]
          , el.caption [] [ C.text "interactive-data" ]
          , el.subCaption [] [ C.text "Define UIs in terms of data types in PureScript" ]
          , el.links []
              ( [ el.link [ C.href "https://github.com/thought2/purescript-interactive-data" ]
                    [ C.text "Github Repo" ]
                , el.link [ C.href "https://interactive-data.app/manual" ]
                    [ C.text "Library Manual" ]
                , el.link [ C.href "https://interactive-data.app/sample-painting-app-halogen" ]
                    [ C.text "Live Demo" ]
                , el.link [ C.href "https://pursuit.purescript.org/packages/purescript-interactive-data" ]
                    [ C.text "API Docs" ]
                ] # intersperse (C.text " | ")
              )
          ]
      ]