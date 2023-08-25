module InteractiveData.App.UI.Header
  ( ViewCfg
  , view
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import InteractiveData.App.UI.Assets as UI.Assets
import InteractiveData.App.UI.Breadcrumbs as UIBreadcrumbs
import InteractiveData.App.UI.DataLabel as UIDataLabel
import InteractiveData.Core.Types.Common (unPathInContext)

type ViewCfg msg =
  { dataPath :: Array DataPathSegment
  , onSelectPath :: Array DataPathSegment -> msg
  , showMenu :: Boolean
  , onSetShowMenu :: Boolean -> msg
  , typeName :: String
  , text :: Maybe String
  }

view :: forall html msg. IDHtml html => ViewCfg msg -> html msg
view { dataPath, typeName, onSelectPath, showMenu, onSetShowMenu, text } =
  viewRoot
    { viewTypeName: viewTypeName { typeName }

    , atDescription: C.text $ fromMaybe "" text

    , viewBreadcrumbs:
        UIBreadcrumbs.view
          { dataPath:
              { before: []
              , path: dataPath
              }
          , viewDataLabel: \(dataPath' :: PathInContext DataPathSegment) ->
              let
                path :: Array DataPathSegment
                path = unPathInContext dataPath'
              in
                UIDataLabel.view
                  { dataPath: dataPath'
                  , mkTitle: UIDataLabel.mkTitleGoto
                  }
                  { onHit: Just $ onSelectPath path
                  , isSelected: true
                  }
          , isAbsolute: true
          }
    , right:
        viewRightCorner
          { showMenu
          , setShowMenu: onSetShowMenu
          }
    }

viewRoot
  :: forall html msg
   . IDHtml html
  => { viewBreadcrumbs :: html msg
     , viewTypeName :: html msg
     , atDescription :: html msg
     , right :: html msg
     }
  -> html msg
viewRoot { viewBreadcrumbs, right } =
  let
    el =
      { header: styleNode C.div
          [ "background-color: #F8F8F8"
          , "padding: 5px"
          , "display: grid"
          , "height: 100%"
          , "box-shadow: 0px 1px 3px #ccc"
          , "justify-content: space-between"
          , "align-items: center"
          , "grid-template-areas: 'a c'"
          ]
      , breadcrumbs: styleNode C.div
          [ "width: 100%"
          , "grid-area: a"
          ]
      , right: styleNode C.div
          [ "grid-area: c" ]
      }
  in
    el.header []
      [ el.breadcrumbs []
          [ viewBreadcrumbs
          ]
      , el.right []
          [ right ]
      ]

viewTypeName
  :: forall html msg
   . IDHtml html
  => { typeName :: String }
  -> html msg
viewTypeName { typeName } =
  let

    el =
      { typeName:
          styleNode C.div
            [ "font-size: 16px"
            , "font-weight: bold"
            ]
      }
  in
    el.typeName []
      [ C.text typeName ]

viewRightCorner
  :: forall html msg
   . IDHtml html
  => { showMenu :: Boolean, setShowMenu :: Boolean -> msg }
  -> html msg
viewRightCorner { showMenu, setShowMenu } =
  let
    el =
      { menuIcon:
          styleNode C.div
            [ "cursor: pointer"
            , "width: 25px"
            , "height: 25px"
            , "fill: black"
            , "display: flex"
            , "justify-content: center"
            ]
      }

  in
    el.menuIcon
      [ C.title (if showMenu then "hide menu" else "show menu")
      , C.onClick $ setShowMenu (not showMenu)
      ]
      [ if showMenu then UI.Assets.viewDotMenuSolid
        else UI.Assets.viewDotMenu
      ]
