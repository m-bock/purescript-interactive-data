module InteractiveData.App.UI.Footer
  ( ViewCfg
  , view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Data.Array as Array
import InteractiveData.App.UI.Assets as UIAssets
import InteractiveData.App.UI.Breadcrumbs as UIBreadcrumbs
import InteractiveData.App.UI.Card as UICard
import InteractiveData.App.UI.DataLabel as UIDataLabel
import InteractiveData.Core.Types.Common (unPathInContext)

type ViewCfg msg =
  { errors :: Array DataError
  , onSelectPath :: Array DataPathSegment -> msg
  , isExpanded :: Boolean
  , onChangeIsExpanded :: Boolean -> msg
  }

view :: forall html msg. IDHtml html => ViewCfg msg -> html msg
view { errors, onSelectPath, isExpanded, onChangeIsExpanded } =
  footerRoot
    { errors
    , isExpanded
    , onChangeIsExpanded
    , viewError:
        footerViewError
          { viewDataPath: \relDataPath ->
              UIBreadcrumbs.view
                { dataPath:
                    { before: []
                    , path: relDataPath
                    }
                , viewDataLabel: \(pathInCtx :: PathInContext DataPathSegment) ->
                    let
                      path :: Array DataPathSegment
                      path = unPathInContext pathInCtx
                    in
                      UIDataLabel.view
                        { dataPath: pathInCtx
                        , mkTitle: UIDataLabel.mkTitleGoto
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
      { footerRoot: styleNode C.div
          [ "display: flex"
          , "flex-direction: column"
          , "align-items: stretch"
          , "background-color: #ffede3"
          , "border-top: 1px solid #eee"
          ]
      , errors: styleNode C.div
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
      , headline: styleNode C.div
          [ "display: flex"
          , "flex-direction: row"
          , "justify-content: space-between"
          , "padding: 5px"
          , "font-size: 12px"
          , "color: #a1a1a1"
          ]
      , expandIcon: styleNode C.div
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
          [ C.text textCountErrors
          , el.expandIcon
              [ C.onClick $ onChangeIsExpanded (not isExpanded) ]
              [ if isExpanded then UIAssets.viewExpandDown
                else UIAssets.viewExpandUp
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
  let
    el = { root: styleNode C.div [ "margin-bottom: 5px" ] }
  in
    el.root []
      [ UICard.view
          UICard.defaultViewOpt
            { viewCaption =
                if Array.null dataPath then Nothing
                else Just $
                  viewDataPath dataPath
            , viewBody = Just
                $ C.text
                $ printErrorCase errorCase_
            , backgroundColor = "#ffd4bc"
            , borderColor = "#ffb2b2"
            }
      ]

printErrorCase :: DataErrorCase -> String
printErrorCase = case _ of
  DataErrNotYetDefined -> "Value not yet defined"
  DataErrMsg msg -> msg