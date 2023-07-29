module InteractiveData.App.UI.Menu.Row
  ( ViewRowCfg
  , ViewRowOpts
  , viewRow
  )
  where

import InteractiveData.Core.Prelude

import DataMVC.Types (DataPath)
import InteractiveData.App.UI.Assets as UI.Assets
import InteractiveData.Core (class IDHtml)
import InteractiveData.Core.Types.DataTree (TreeMeta)
import VirtualDOM as VD

type ViewRowCfg msg =
  { onSetExpanded :: DataPath -> Boolean -> msg
  }

type ViewRowOpts (html :: Type -> Type) msg =
  { isExpanded :: Boolean
  , path :: DataPath
  , isLeaf :: Boolean
  , meta :: TreeMeta
  , viewLabel :: html msg
  }

viewRow
  :: forall html msg
   . IDHtml html
  => ViewRowCfg msg
  -> ViewRowOpts html msg
  -> html msg
viewRow { onSetExpanded } { viewLabel, path, isExpanded, isLeaf } =
  let
    el =
      { row: styleNode VD.div
          [ "display: flex; "
          , "align-items: center"
          , "padding: 5px"
          ]
      , icon: styleNode VD.div
          [ "cursor: pointer"
          , "width: 20px"
          , "height: 20px"
          , if isExpanded then "transform: rotate(90deg)" else ""
          , "transition: transform 100ms ease-in-out"
          , "display: flex"
          , "align-items: center"
          , "justify-content: center"
          ]
      , iconInner: styleNode VD.div
          [ "height: 24px"
          , "width: 14px"
          , "scale: 0.4"
          ]
      }

  in
    el.row []
      [ el.icon
          [ if isLeaf then VD.noProp
            else VD.onClick (onSetExpanded path (not isExpanded))
          ]
          [ if isLeaf then VD.noHtml
            else el.iconInner [] [ UI.Assets.viewChevronRight ]
          ]
      , viewLabel
      ]
