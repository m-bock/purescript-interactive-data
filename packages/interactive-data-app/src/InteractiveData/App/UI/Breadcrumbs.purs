module InteractiveData.App.UI.Breadcrumbs
  ( viewBreadcrumbs
  ) where

import InteractiveData.Core.Prelude

import Chameleon as VD
import Data.Array (intersperse)
import Data.Array as Array
import InteractiveData.App.UI.Assets as UI.Assets

viewBreadcrumbs
  :: forall html msg
   . IDHtml html
  => { viewDataLabel :: PathInContext DataPathSegment -> html msg
     , dataPath :: PathInContext DataPathSegment
     , isAbsolute :: Boolean
     }
  -> html msg
viewBreadcrumbs { dataPath, viewDataLabel, isAbsolute } =
  let

    el =
      { root: styleNode VD.div
          [ "display: flex"
          , "align-items: center"
          ]
      , iconArrow: styleNode VD.div
          [ "height: 24px"
          , "width: 14px"
          , "scale: 0.3"
          ]
      }

    rootSegment :: html msg
    rootSegment = viewDataLabel { before: [], path: [] }

    segments :: Array (html msg)
    segments = dataPath.path
      # initsWithLast
      # map
          ( \(xs /\ _) ->
              viewDataLabel { before: dataPath.before, path: xs }
          )

    allSegments :: Array (html msg)
    allSegments =
      if isAbsolute then [ rootSegment ] <> segments
      else segments
  in
    el.root []
      ( allSegments
          # intersperse
              ( VD.div_
                  [ el.iconArrow
                      []
                      [ UI.Assets.viewChevronRight ]
                  ]
              )
      )

initsWithLast :: forall a. Array a -> Array (Array a /\ a)
initsWithLast items = case Array.unsnoc items of
  Nothing -> []
  Just { init, last } -> initsWithLast init <> [ items /\ last ]
