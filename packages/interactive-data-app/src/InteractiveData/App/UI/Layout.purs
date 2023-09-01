module InteractiveData.App.UI.Layout
  ( ViewCfg
  , view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Chameleon.HTML.Elements as VDE
import InteractiveData.App.EnvVars (envVars)

type ViewCfg (html :: Type -> Type) msg =
  { viewHeader :: html msg
  , viewSidebar :: Maybe (html msg)
  , viewBody :: html msg
  , viewFooter :: Maybe (html msg)
  }

-- TODO: Find a better way to load the font
viewEmbedFont :: forall html msg. IDHtml html => html msg
viewEmbedFont = VDE.style []
  [ C.text "@import url('https://fonts.googleapis.com/css2?family=Signika+Negative:wght@300&display=swap')" ]

view :: forall html msg. IDHtml html => ViewCfg html msg -> html msg
view { viewHeader, viewSidebar, viewBody, viewFooter } = withCtx \ctx ->
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
          [ "position: sticky"
          , "top: 0"
          , "z-index: 99"
          , "height: 25px"
          ]
      , root: styleNode C.div
          [ "width: 100%"
          , "display: flex"
          , "height: 100%"
          ]
      , sidebar: styleNode C.div
          $
            ( if showSidebar then
                [ "width: 120px"
                , "border-right: 1px solid #E0E0E0"
                ]
              else
                [ "width: 0px" ]
            )
          /\
            [ "transition: width 100ms ease-in-out"
            , "flex: 0 0 auto;"
            ]
      , body: styleNode C.div
          $
            [ "height: 100%"
            , "display: flex"
            , "flex-direction: column"
            , "flex: 1"
            ]
          <>
            if showSidebar then
              [ "max-width: calc(100% - 120px)"
              ]
            else
              [ "max-width: 100%" ]

      , main: styleNode C.div
          [ "display: flex"
          , "flex-direction: column"
          , "height: 100%"
          , "overflow-y: auto"
          ]
      , footer: styleNode C.div
          [ "width: 100%"
          ]
      , content: styleNode C.div
          "flex-grow: 1"
      }
  in
    el.layout
      [ C.attr "data-version" envVars.version ]
      [ viewEmbedFont
      , el.root []
          [ el.sidebar []
              [ case viewSidebar of
                  Just view' ->
                    view'
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
                  Just view' ->
                    el.footer []
                      [ view' ]
                  Nothing -> C.noHtml
              ]
          ]
      ]