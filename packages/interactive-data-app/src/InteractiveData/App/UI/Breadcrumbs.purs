module InteractiveData.App.UI.Breadcrumbs
  ( viewBreadcrumbs
  ) where

import InteractiveData.Core.Prelude

import Data.Array (intersperse)
import Data.Array as Array
import InteractiveData.App.UI.Icons as UI.Icons
import InteractiveData.Core (class IDHtml, DataPathSegment)
import InteractiveData.Core.Types.Common (PathInContext)
import VirtualDOM as VD
import VirtualDOM.Styled (styleNode)

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
          # intersperse (VD.div_ [ UI.Icons.breadCrumb ])
      )

initsWithLast :: forall a. Array a -> Array (Array a /\ a)
initsWithLast items = case Array.unsnoc items of
  Nothing -> []
  Just { init, last } -> initsWithLast init <> [ items /\ last ]
