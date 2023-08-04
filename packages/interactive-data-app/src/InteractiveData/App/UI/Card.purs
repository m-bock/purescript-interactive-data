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
  , backgroundColor :: String
  , borderColor :: String
  }

defaultViewCardOpt :: forall html msg. ViewCardOpt html msg
defaultViewCardOpt =
  { viewCaption: Nothing
  , backgroundColor: "#f8f8f8"
  , borderColor: "#ddd"
  }

viewCard
  :: forall html msg
   . IDHtml html
  => ViewCardCfg html msg
  -> ViewCardOpt html msg
  -> html msg
viewCard { viewBody } { viewCaption, backgroundColor, borderColor } =
  let
    el =

      { card: styleNode VD.div
          [ "background-color: " <> backgroundColor
          , "margin-bottom: 20px"
          , "position: relative"
          , "border-radius: 5px"
          , "padding-bottom: 5px"
          , "padding-top: 5px"
          , "border: 1px solid " <> borderColor
          ]
      , caption: styleNode VD.div
          [ "margin-bottom: 10px"
          , "border-bottom: 1px solid " <> borderColor
          , "padding-bottom: 5px"
          , "padding-left: 5px"
          , "padding-right: 5px"
          ]
      , body: styleNode VD.div
          [ "padding-left: 5px"
          , "padding-right: 5px"
          ]
      }
  in
    el.card []
      [ case viewCaption of
          Just viewCaption' ->
            el.caption [] [ viewCaption' ]
          Nothing ->
            VD.noHtml
      , el.body []
          [ viewBody ]
      ]
