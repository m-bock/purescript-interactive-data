module InteractiveData.App.UI.Header
  ( ViewHeaderCfg
  , viewHeader
  ) where

import InteractiveData.Core.Prelude

import InteractiveData.App.UI.Assets as UI.Assets
import InteractiveData.App.UI.Breadcrumbs as UI.Breadcrumbs
import InteractiveData.App.UI.DataLabel as UI.DataLabel
import InteractiveData.Core.Types.Common (unPathInContext)
import Chameleon as VD

type ViewHeaderCfg msg =
  { dataPath :: Array DataPathSegment
  , onSelectPath :: Array DataPathSegment -> msg
  , showMenu :: Boolean
  , onSetShowMenu :: Boolean -> msg
  , typeName :: String
  }

viewHeader :: forall html msg. IDHtml html => ViewHeaderCfg msg -> html msg
viewHeader { dataPath, typeName, onSelectPath, showMenu, onSetShowMenu } =
  viewHeaderRoot
    { viewTypeName: viewTypeName { typeName }

    , viewBreadcrumbs:
        UI.Breadcrumbs.viewBreadcrumbs
          { dataPath:
              { before: []
              , path: dataPath
              }
          , viewDataLabel: \(dataPath' :: PathInContext DataPathSegment) ->
              let
                path :: Array DataPathSegment
                path = unPathInContext dataPath'
              in
                UI.DataLabel.viewDataLabel
                  { dataPath: dataPath'
                  , mkTitle: UI.DataLabel.mkTitleGoto
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

viewHeaderRoot
  :: forall html msg
   . IDHtml html
  => { viewBreadcrumbs :: html msg
     , viewTypeName :: html msg
     , right :: html msg
     }
  -> html msg
viewHeaderRoot { viewBreadcrumbs, viewTypeName: viewTypeName', right } =
  let
    el =
      { header: styleNode VD.div
          [ "background-color: #F8F8F8"
          , "padding: 5px"
          , "display: grid"
          , "gap: 5px"
          , "height: 100%"
          , "box-shadow: 0px 1px 3px #ccc"
          , "justify-content: space-between"
          , "align-items: center"
          , "grid-template-areas: 'a c' 'b d'"
          ]
      , typeName: styleNode VD.div
          [ "font-size: 20px"
          , "grid-area: b"
          ]
      , breadcrumbs: styleNode VD.div
          [ "width: 100%"
          , "grid-area: a"
          ]
      , right: styleNode VD.div
          [ "grid-area: c" ]
      }
  in
    el.header [ VD.id "header" ]
      [ el.breadcrumbs []
          [ viewBreadcrumbs
          ]
      , el.typeName []
          [ viewTypeName' ]
      , el.right []
          [ right ]
      ]

-- viewIcon :: forall html msg. IDHtml html => html msg -> html msg
-- viewIcon view =
--   let
--     el =
--       { root:
--           styleNode VD.div
--             $ declWith " > svg"
--                 [ "width:10px"
--                 , "height:10px"
--                 , "display:inline-block"
--                 ]
--       }
--   in
--     el.root []
--       [ view ]

viewTypeName
  :: forall html msg
   . IDHtml html
  => { typeName :: String }
  -> html msg
viewTypeName { typeName } =
  let

    el =
      { typeName:
          styleNode VD.div
            [ "font-size: 16px"
            , "font-weight: bold"
            ]
      }
  in
    el.typeName []
      [ VD.text typeName ]

viewRightCorner :: forall html msg. IDHtml html => { showMenu :: Boolean, setShowMenu :: Boolean -> msg } -> html msg
viewRightCorner { showMenu, setShowMenu } =
  let
    el =
      { menuIcon:
          styleNode VD.div
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
      [ VD.title (if showMenu then "hide menu" else "show menu")
      , VD.onClick $ setShowMenu (not showMenu)
      ]
      [ if showMenu then UI.Assets.viewDotMenuSolid
        else UI.Assets.viewDotMenu
      ]
