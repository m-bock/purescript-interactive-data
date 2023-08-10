module InteractiveData.App.UI.ActionButton
  ( ViewActionButtonCfg
  , viewActionButton
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Chameleon.Transformers.OutMsg.Class (fromOutHtml)

type ViewActionButtonCfg msg =
  { dataAction :: DataAction msg
  }

viewActionButton :: forall html msg. IDHtml html => ViewActionButtonCfg msg -> html msg
viewActionButton { dataAction } =
  let
    DataAction { label, description, msg } = dataAction

    el =

      { actionButton: styleNode C.div
          $
            [ declWith ":hover"
                [ "background-color: #c1ebfa" ]
            ]
          /\
            decl
              [ "background-color: #e9f9ff" ]
          /\
            [ "border: 1px solid #ccc"
            , "margin: 5px"
            , "padding: 3px"
            , "cursor: pointer"
            , "font-size: 12px"
            , "border-radius: 3px"
            , "user-select: none"
            ]
      }
  in
    fromOutHtml $ el.actionButton
      [ C.onClick msg
      , C.title description
      ]
      [ C.text label ]