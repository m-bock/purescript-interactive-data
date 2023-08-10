module InteractiveData.App.FastForward.Standalone
  ( view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Data.Array as Array
import Data.FunctorWithIndex (mapWithIndex)

view
  :: forall html msg
   . IDHtml html
  => Array (DataPath /\ DataTree html msg)
  -> html msg
view items =
  let
    el =
      { root: styleNode C.div [ "" ]
      , item: styleNode C.div
          $
            [ "margin-bottom: 20px"
            ]
          /\ declWith ":not(:last-child)"
            [ "border-bottom: 1px solid #ccc"
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
                      [ viewItem { isLast, isFirst } item ]
              )
      )

viewItem
  :: forall html msg
   . IDHtml html
  => { isLast :: Boolean, isFirst :: Boolean }
  -> DataPath /\ DataTree html msg
  -> html msg
viewItem { isLast } (path /\ tree) =
  let
    el =
      { root: styleNode C.div
          $ [ "margin-left: 20px" ]
      }

    DataTree { view } = tree

  in
    withCtx \(ctx :: IDViewCtx) ->
      el.root []
        [ withCtx \_ -> putCtx ctx { fastForward = isLast, path = path } $ view
        ]
