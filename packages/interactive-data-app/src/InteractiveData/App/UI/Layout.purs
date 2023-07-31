module InteractiveData.App.UI.Layout
  ( ViewLayoutCfg
  , viewLayout
  ) where

import InteractiveData.Core.Prelude

import InteractiveData.Core (class IDHtml)
import Chameleon as VD
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
  [ VD.text "@import url('https://fonts.googleapis.com/css2?family=Signika+Negative:wght@300&display=swap')" ]

viewLayout :: forall html msg. IDHtml html => ViewLayoutCfg html msg -> html msg
viewLayout { viewHeader, viewSidebar, viewBody, viewFooter } = withCtx \ctx ->
  let
    showSidebar :: Boolean
    showSidebar = isJust viewSidebar

    el =
      { layout: styleNode VD.div
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
            ]
      , header: styleNode VD.div
          [ "min-height: 70px"
          , "position: sticky"
          , "top: 0"
          , "z-index: 99"
          ]
      , root: styleNode VD.div
          [ "width: 100%"
          , "overflow-y: auto"
          , "display: flex"
          , "height: 100%"
          ]
      , sidebar: styleNode VD.div
          [ "border-right: 1px solid #E0E0E0"
          , if showSidebar then "width: 250px"
            else "width: 0px"
          , "transition: width 100ms ease-in-out"
          ]
      , body: styleNode VD.div
          [ "width: 100%"
          , "height: 100%"
          , "overflow: none"
          , "display: flex"
          , "flex-direction: column"

          ]
      , main: styleNode VD.div
          [ "overflow-y: auto"
          , "display: flex"
          , "flex-direction: column"
          , "height: 100%"
          ]
      , footer: styleNode VD.div
          [ "width: 100%"
          ]
      , content: styleNode VD.div
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
                  Nothing -> VD.noHtml
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
                  Nothing -> VD.noHtml
              ]
          ]
      ]