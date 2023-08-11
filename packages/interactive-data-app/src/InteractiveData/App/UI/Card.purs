module InteractiveData.App.UI.Card
  ( ViewCfg
  , ViewOpt
  , defaultViewOpt
  , view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C

type ViewCfg (html :: Type -> Type) msg =
  { viewBody :: html msg
  }

type ViewOpt (html :: Type -> Type) msg =
  { viewCaption :: Maybe (html msg)
  , viewSubCaption :: Maybe (html msg)
  , backgroundColor :: String
  , borderColor :: String
  }

defaultViewOpt :: forall html msg. ViewOpt html msg
defaultViewOpt =
  { viewCaption: Nothing
  , viewSubCaption: Nothing
  , backgroundColor: "#f8f8f8"
  , borderColor: "#ddd"
  }

view
  :: forall html msg
   . IDHtml html
  => ViewCfg html msg
  -> ViewOpt html msg
  -> html msg
view { viewBody } { viewCaption, viewSubCaption, backgroundColor, borderColor } =
  let
    el =

      { card: styleNode C.div
          [ "background-color: " <> backgroundColor
          , "position: relative"
          , "border-radius: 5px"
          , "border: 1px solid " <> borderColor
          , "height: 100%"
          , "width: 100%"
          , "display: flex"
          , "flex-direction: column"
          , "box-sizing: border-box"
          ]
      , caption: styleNode C.div
          [ "border-bottom: 1px solid " <> borderColor
          , "padding: 5px"
          , "height: 35px"
          , "box-sizing: border-box"
          ]
      , subCaption: styleNode C.div
          [ "padding: 5px"
          , "height: 25px"
          , "box-sizing: border-box"
          ]
      , body: styleNode C.div
          [ "padding-left: 5px"
          , "padding-right: 5px"
          , "margin-top: 10px"
          , "box-sizing: border-box"
          ]
      }
  in
    el.card []
      [ case viewCaption of
          Just viewCaption' ->
            el.caption [] [ viewCaption' ]
          Nothing ->
            C.noHtml
      , case viewSubCaption of
          Just viewSubCaption' ->
            el.subCaption [] [ viewSubCaption' ]
          Nothing ->
            C.noHtml
      , el.body []
          [ viewBody ]
      ]
