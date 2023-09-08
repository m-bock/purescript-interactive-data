module InteractiveData.App.UI.Breadcrumbs
  ( ViewCfg
  , view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Data.Array (intersperse)
import Data.Array as Array
import InteractiveData.App.UI.Assets as UI.Assets

type ViewCfg (html :: Type -> Type) msg =
  { viewDataLabel :: PathInContext DataPathSegment -> html msg
  , dataPath :: PathInContext DataPathSegment
  , isAbsolute :: Boolean
  }

view
  :: forall html msg
   . IDHtml html
  => ViewCfg html msg
  -> html msg
view { dataPath, viewDataLabel, isAbsolute } =
  let

    el = styleElems "InteractiveData.App.UI.Breadcrumbs#view"
      { root: C.div /\
          [ "display: flex"
          , "align-items: center"
          ]
      , iconArrow: C.div /\
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
    el.root_
      ( allSegments
          # intersperse
              ( C.div_
                  [ el.iconArrow_
                      [ UI.Assets.viewChevronRight ]
                  ]
              )
      )

initsWithLast :: forall a. Array a -> Array (Array a /\ a)
initsWithLast items = case Array.unsnoc items of
  Nothing -> []
  Just { init, last } -> initsWithLast init <> [ items /\ last ]
