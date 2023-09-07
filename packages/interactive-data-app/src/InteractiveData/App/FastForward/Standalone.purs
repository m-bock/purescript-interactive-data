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
    el = styleElems
      "InteractiveData.App.FastForward.Standalone#view"
      { root: C.div
      , item: C.div
          /\ declWith ":not(:last-child)"
            [ "margin-bottom: 20px"
            , "border-bottom: 1px solid #ccc"
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
      { root: C.div
      }

    DataTree { view } = tree

  in
    withCtx \(ctx :: IDViewCtx) ->
      el.root []
        [ withCtx \_ -> putCtx ctx { fastForward = isLast, path = path } $ view ]
