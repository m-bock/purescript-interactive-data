module InteractiveData.App.WrapData.NewStandalone where

import InteractiveData.Core.Prelude

import Chameleon as VD
import Chameleon.Transformers.OutMsg.Class (fromOutHtml)
import Data.Array as Array
import Data.FunctorWithIndex (mapWithIndex)
import InteractiveData.App.UI.DataLabel as UI.DataLabel
import InteractiveData.Core.Types.DataPathExtra (dataPathToStrings)

viewNewStandalone
  :: forall html msg
   . IDHtml html
  => Array (DataPath /\ DataTree html msg)
  -> html msg
viewNewStandalone items =
  let
    el =
      { root: styleNode VD.div [ "" ]
      , item: styleNode VD.div
          [ "margin-bottom: 20px"
          ]
      }

    countItems = Array.length items
  in
    el.root []
      ( items
          # mapWithIndex
              ( \index item ->
                  let
                    isLast = index == countItems - 1
                    isFirst = index == 0
                  in
                    el.item []
                      [ viewNewItemStandalone { isLast, isFirst } item ]
              )
      )

viewNewItemStandalone
  :: forall html msg
   . IDHtml html
  => { isLast :: Boolean, isFirst :: Boolean }
  -> DataPath /\ DataTree html msg
  -> html msg
viewNewItemStandalone { isLast, isFirst } (path /\ tree) =
  let
    el =
      { root: styleNode VD.div [ "margin-left: 20px" ]
      }

    DataTree { view } = tree

  in
    withCtx \(ctx :: IDViewCtx) ->
      el.root []
        [ if isFirst then VD.noHtml
          else fromOutHtml
            $ UI.DataLabel.viewDataLabel
                { dataPath: { before: [], path }
                , mkTitle: UI.DataLabel.mkTitleGoto
                }
                { onHit: Just (That $ GlobalSelectDataPath $ dataPathToStrings path)
                , size: UI.DataLabel.Large
                }
        , withCtx \_ -> putCtx ctx { fastForward = isLast, path = path } $ view
        , VD.hr_
        ]
