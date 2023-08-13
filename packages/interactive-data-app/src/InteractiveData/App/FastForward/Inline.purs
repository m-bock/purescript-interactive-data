module InteractiveData.App.FastForward.Inline
  ( view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Data.Array (intersperse)
import Data.Array as Array
import Data.FunctorWithIndex (mapWithIndex)
import InteractiveData.App.UI.Assets as UI.Assets

view
  :: forall html msg
   . IDHtml html
  => Array (DataPath /\ DataTree html msg)
  -> html msg
view items =
  let
    el =
      { root: styleNode C.div
          [ "display: flex"
          , "flex-direction: row"
          , "margin-bottom: 20px"
          , "justify-content: space-between"
          , "align-items: start"
          ]
      , spacer: styleNode C.div
          [ "width: 15px" ]
      , item: C.div
      , lastItem: styleNode C.div
          [ "flex-grow: 1" ]
      , iconArrow: styleNode C.div
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
viewItem (path /\ DataTree { view: view' }) =
  withCtx \ctx -> putCtx ctx { path = path } $ view'
