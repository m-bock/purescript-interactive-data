module InteractiveData.App.UI.Card
  ( ViewCardCfg
  , ViewCardOpt
  , defaultViewCardOpt
  , viewCard
  ) where

import InteractiveData.Core.Prelude

import Chameleon as VD

type ViewCardCfg (html :: Type -> Type) msg =
  { viewBody :: html msg
  }

type ViewCardOpt (html :: Type -> Type) msg =
  { viewCaption :: Maybe (html msg)
  , viewSubCaption :: Maybe (html msg)
  , backgroundColor :: String
  , borderColor :: String
  }

defaultViewCardOpt :: forall html msg. ViewCardOpt html msg
defaultViewCardOpt =
  { viewCaption: Nothing
  , viewSubCaption: Nothing
  , backgroundColor: "#f8f8f8"
  , borderColor: "#ddd"
  }

viewCard
  :: forall html msg
   . IDHtml html
  => ViewCardCfg html msg
  -> ViewCardOpt html msg
  -> html msg
viewCard { viewBody } { viewCaption, viewSubCaption, backgroundColor, borderColor } =
  let
    el =

      { card: styleNode VD.div
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
      , caption: styleNode VD.div
          [ "border-bottom: 1px solid " <> borderColor
          , "padding: 5px"
          , "height: 35px"
          , "box-sizing: border-box"
          ]
      , subCaption: styleNode VD.div
          [ "padding: 5px"
          , "height: 25px"
          , "box-sizing: border-box"
          ]
      , body: styleNode VD.div
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
            VD.noHtml
      , case viewSubCaption of
          Just viewSubCaption' ->
            el.subCaption [] [ viewSubCaption' ]
          Nothing ->
            VD.noHtml
      , el.body []
          [ viewBody ]
      ]
