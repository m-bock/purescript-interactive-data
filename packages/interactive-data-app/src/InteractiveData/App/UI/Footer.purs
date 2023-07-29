module InteractiveData.App.UI.Footer
  ( ViewFooterCfg
  , viewFooter
  ) where

import InteractiveData.Core.Prelude

import Data.Array as Array
import DataMVC.Types (DataErrorCase(..), DataPath, DataPathSegment)
import DataMVC.Types.DataError (DataError(..))
import InteractiveData.App.UI.Assets as UI.Assets
import InteractiveData.App.UI.Breadcrumbs as UI.Breadcrumbs
import InteractiveData.App.UI.Card as UI.Card
import InteractiveData.App.UI.DataLabel as UI.DataLabel
import InteractiveData.Core (class IDHtml)
import InteractiveData.Core.Types.Common (PathInContext, unPathInContext)
import VirtualDOM as VD

type ViewFooterCfg msg =
  { errors :: Array DataError
  , onSelectPath :: Array DataPathSegment -> msg
  , isExpanded :: Boolean
  , onChangeIsExpanded :: Boolean -> msg
  }

viewFooter :: forall html msg. IDHtml html => ViewFooterCfg msg -> html msg
viewFooter { errors, onSelectPath, isExpanded, onChangeIsExpanded } =
  footerRoot
    { errors
    , isExpanded
    , onChangeIsExpanded
    , viewError:
        footerViewError
          { viewDataPath: \relDataPath ->
              UI.Breadcrumbs.viewBreadcrumbs
                { dataPath:
                    { before: []
                    , path: relDataPath
                    }
                , viewDataLabel: \(pathInCtx :: PathInContext DataPathSegment) ->
                    let
                      path :: Array DataPathSegment
                      path = unPathInContext pathInCtx
                    in
                      UI.DataLabel.viewDataLabel
                        { dataPath: pathInCtx
                        , mkTitle: UI.DataLabel.mkTitleGoto
                        }
                        { onHit: Just $ onSelectPath path
                        , isSelected: true
                        }
                , isAbsolute: false
                }

          }
    }

footerRoot
  :: forall html msg
   . IDHtml html
  => { errors :: Array DataError
     , viewError :: DataError -> html msg
     , isExpanded :: Boolean
     , onChangeIsExpanded :: Boolean -> msg
     }
  -> html msg
footerRoot { errors, viewError, isExpanded, onChangeIsExpanded } =
  let
    el =
      { footerRoot: styleNode VD.div
          [ "display: flex"
          , "flex-direction: column"
          , "align-items: stretch"
          , "background-color: #ffede3"
          , "border-top: 1px solid #eee"
          ]
      , errors: styleNode VD.div
          $
            [ "overflow-y: auto"
            , "flex-grow: 1"
            , "max-height: 200px"

            , "transition: max-height 100ms ease-in-out"
            , "padding-left: 5px"
            , "padding-right: 5px"

            ]
          <>
            if isExpanded then
              [ "max-height: 200px"
              ]
            else
              [ "max-height: 0px"
              ]
      , headline: styleNode VD.div
          [ "display: flex"
          , "flex-direction: row"
          , "justify-content: space-between"
          , "padding: 5px"
          ]
      , expandIcon: styleNode VD.div
          [ "cursor: pointer"
          , "width: 20px"
          ]
      }

    countErrors :: Int
    countErrors = Array.length errors

    textCountErrors :: String
    textCountErrors = case countErrors of
      0 -> "No errors"
      1 -> "1 error"
      _ -> show countErrors <> " errors"
  in
    el.footerRoot []
      [ el.headline []
          [ VD.text textCountErrors
          , el.expandIcon
              [ VD.onClick $ onChangeIsExpanded (not isExpanded) ]
              [ if isExpanded then UI.Assets.viewExpandDown
                else UI.Assets.viewExpandUp
              ]
          ]
      , el.errors []
          (errors # map viewError)
      ]

footerViewError
  :: forall html msg
   . IDHtml html
  => { viewDataPath :: DataPath -> html msg
     }
  -> DataError
  -> html msg
footerViewError { viewDataPath } (DataError dataPath errorCase_) = withCtx \_ ->
  UI.Card.viewCard
    { viewBody:
        VD.text $ printErrorCase errorCase_
    }
    UI.Card.defaultViewCardOpt
      { viewCaption =
          if Array.null dataPath then Nothing
          else Just $
            viewDataPath dataPath
      , backgroundColor = "#ffd4bc"
      , borderColor = "#ffb2b2"
      }

printErrorCase :: DataErrorCase -> String
printErrorCase = case _ of
  DataErrNotYetDefined -> "Value not yet defined"
  DataErrMsg msg -> msg