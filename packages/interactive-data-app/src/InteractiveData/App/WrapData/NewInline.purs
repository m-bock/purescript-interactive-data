module InteractiveData.App.WrapData.NewInline where

import InteractiveData.Core.Prelude

import Chameleon as VD
import Chameleon.Transformers.OutMsg.Class (fromOutHtml)
import Data.Array (intersperse)
import Data.Array as Array
import Data.FunctorWithIndex (mapWithIndex)
import InteractiveData.App.UI.Card as UI.Card
import InteractiveData.App.UI.DataLabel as UI.DataLabel
import InteractiveData.Core.Types.DataPathExtra (dataPathToStrings)

viewNewInline
  :: forall html msg
   . IDHtml html
  => Array (DataPath /\ DataTree html msg)
  -> html msg
viewNewInline items =
  let
    el =
      { root: styleNode VD.div
          [ "display: flex"
          , "flex-direction: row"
          , "margin-bottom: 20px"
          , "justify-content: space-between"
          ]
      , spacer: styleNode VD.div
          [ "width: 15px"
          ]
      , item: styleNode VD.div
          [ "" ]
      , lastItem: styleNode VD.div
          [ "flex-grow: 1" ]
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
                  [ viewNewItem item ]
              else
                el.item []
                  [ viewNewItem item ]
          )
          items
          # intersperse (el.spacer [] [ VD.text ">" ])
      )

viewNewItem
  :: forall html msg
   . IDHtml html
  => DataPath /\ DataTree html msg
  -> html msg
viewNewItem (path /\ DataTree { view }) =
  UI.Card.viewCard
    { viewBody: withCtx \ctx -> putCtx ctx { fastForward = false, path = path } $ view
    }
    UI.Card.defaultViewCardOpt
      { viewCaption = Just
          $ fromOutHtml
          $ UI.DataLabel.viewDataLabel
              { dataPath: { before: [], path }
              , mkTitle: UI.DataLabel.mkTitleGoto
              }
              { onHit: Just (That $ GlobalSelectDataPath $ dataPathToStrings path)
              , size: UI.DataLabel.Large
              }
      }
