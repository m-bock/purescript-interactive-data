module InteractiveData.App.UI.Layout
  ( ViewLayoutCfg
  , viewLayout
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Chameleon.HTML.Elements as VDE

type ViewLayoutCfg (html :: Type -> Type) msg =
  { viewHeader :: html msg
  , viewSidebar :: Maybe (html msg)
  , viewBody :: html msg
  , viewFooter :: Maybe (html msg)
  }

-- TODO: Find a better way to load the font
viewEmbedFont :: forall html msg. IDHtml html => html msg
viewEmbedFont = VDE.style []
  [ C.text "@import url('https://fonts.googleapis.com/css2?family=Signika+Negative:wght@300&display=swap')" ]

viewLayout :: forall html msg. IDHtml html => ViewLayoutCfg html msg -> html msg
viewLayout { viewHeader, viewSidebar, viewBody, viewFooter } = withCtx \ctx ->
  let
    showSidebar :: Boolean
    showSidebar = isJust viewSidebar

    el =
      { layout: styleNode C.div
          $
            ( if ctx.fullscreen then
                [ "position: fixed"
                , "top: 0px"
                , "left: 0px"
                , "right: 0px"
                , "bottom: 0px"
                ]
              else []
            )
          /\
            [ "display: flex"
            , "flex-direction: column"
            , "height: 100%"
            , "font-family: 'Signika Negative'"
            , "background-color: white"
            ]
      , header: styleNode C.div
          [ "min-height: 70px"
          , "position: sticky"
          , "top: 0"
          , "z-index: 99"
          ]
      , root: styleNode C.div
          [ "width: 100%"
          , "overflow-y: auto"
          , "display: flex"
          , "height: 100%"
          ]
      , sidebar: styleNode C.div
          $
            ( if showSidebar then
                [ "width: 250px"
                , "border-right: 1px solid #E0E0E0"
                ]
              else
                [ "width: 0px" ]
            )
          /\
            [ "transition: width 100ms ease-in-out"
            ]
      , body: styleNode C.div
          [ "width: 100%"
          , "height: 100%"
          , "overflow: none"
          , "display: flex"
          , "flex-direction: column"

          ]
      , main: styleNode C.div
          [ "overflow-y: auto"
          , "display: flex"
          , "flex-direction: column"
          , "height: 100%"
          ]
      , footer: styleNode C.div
          [ "width: 100%"
          ]
      , content: styleNode C.div
          "flex-grow: 1"
      }
  in
    el.layout []
      [ viewEmbedFont
      , el.root []
          [ el.sidebar []
              [ case viewSidebar of
                  Just view ->
                    view
                  Nothing -> C.noHtml
              ]
          , el.body []
              [ el.main []
                  [ el.header []
                      [ viewHeader ]
                  , el.content []
                      [ viewBody ]
                  ]
              , case viewFooter of
                  Just view ->
                    el.footer []
                      [ view ]
                  Nothing -> C.noHtml
              ]
          ]
      ]