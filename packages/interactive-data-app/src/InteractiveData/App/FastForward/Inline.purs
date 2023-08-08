module InteractiveData.App.FastForward.Inline
  ( viewFastForwardInline
  )
  where

import InteractiveData.Core.Prelude

import Chameleon as VD
import Data.Array (intersperse)
import Data.Array as Array
import Data.FunctorWithIndex (mapWithIndex)
import InteractiveData.App.UI.Assets as UI.Assets

viewFastForwardInline
  :: forall html msg
   . IDHtml html
  => Array (DataPath /\ DataTree html msg)
  -> html msg
viewFastForwardInline items =
  let
    el =
      { root: styleNode VD.div
          [ "display: flex"
          , "flex-direction: row"
          , "margin-bottom: 20px"
          , "justify-content: space-between"
          , "align-items: center"
          ]
      , spacer: styleNode VD.div
          [ "width: 15px"
          ]
      , item: styleNode VD.div
          [ "" ]
      , lastItem: styleNode VD.div
          [ "flex-grow: 1" ]
      , iconArrow: styleNode VD.div
          [ "height: 24px"
          , "width: 14px"
          , "scale: 0.3"
          , "fill: #8b8b8b"
          ]
      }

    itemsCount :: Int
    itemsCount =
      Array.length items

  in
    el.root []
      ( mapWithIndex
          ( \ix item ->
              if ix == itemsCount - 1 then
                el.lastItem []
                  [ viewItem item ]
              else
                el.item []
                  [ viewItem item ]
          )
          items
          # intersperse
              ( el.spacer []
                  [ el.iconArrow []
                      [ UI.Assets.viewChevronRight
                      ]
                  ]
              )
      )

viewItem
  :: forall html msg
   . IDHtml html
  => DataPath /\ DataTree html msg
  -> html msg
viewItem (path /\ DataTree { view }) =
  withCtx \ctx -> putCtx ctx { path = path } $ view
