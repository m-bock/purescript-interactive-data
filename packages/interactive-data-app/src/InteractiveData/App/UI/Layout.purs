module InteractiveData.App.UI.Layout
  ( ViewCfg
  , view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Chameleon.HTML.Elements as VDE
import Data.Monoid (guard)
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

    el = styleElems
      "InteractiveData.App.UI.Layout#view"
      { root: C.div
          /\
            guard ctx.fullscreen
              [ "position: fixed"
              , "top: 0px"
              , "left: 0px"
              , "right: 0px"
              , "bottom: 0px"
              ]
          /\
            [ "display: flex"
            , "flex-direction: column"
            , "height: 100%"
            , "font-family: 'Signika Negative'"
            , "background-color: white"
            ]
      , header: C.div /\ [ "z-index: 3000" ]
      , layout: C.div /\
          [ "width: 100%"
          , "display: flex"
          , "height: 100%"
          ]
      , sidebar: C.div
          /\
            ( if showSidebar then
                [ "border-right: 1px solid #E0E0E0"
                , "min-width: 140px"
                ]
              else
                [ "width: 0px" ]
            )
          /\
            [ "transition: width 100ms ease-in-out"
            , "flex: 0 0 auto;"
            ]
      , main: C.div /\
          ( [ "height: 100%"
            , "display: flex"
            , "flex-direction: column"
            , "flex: 1"
            ]
          )

      , footer: C.div /\
          [ "width: 100%"
          ]
      , content: C.div /\
          [ "flex-grow: 1"
          , "overflow-y: auto"
          ]
      }
  in
    el.root
      [ C.attr "data-version" envVars.version ]
      [ viewEmbedFont
      , el.layout []
          [ el.sidebar []
              [ case viewSidebar of
                  Just view' ->
                    view'
                  Nothing -> C.noHtml
              ]
          , el.main []
              [ el.header []
                  [ viewHeader ]
              , el.content []
                  [ viewBody ]
              , case viewFooter of
                  Just view' ->
                    el.footer []
                      [ view' ]
                  Nothing -> C.noHtml
              ]

          ]
      ]