module InteractiveData.App.UI.DataLabel
  ( Size(..)
  , ViewDataLabelCfg
  , ViewDataLabelOpt
  , mkTitleGoto
  , mkTitleSelect
  , viewDataLabel
  ) where

import InteractiveData.Core.Prelude

import Data.Array as Array
import Data.String as Str
import Data.Tuple (fst)
import DataMVC.Types (DataPathSegment(..), DataPath)
import InteractiveData.App.UI.Assets as UI.Assets
import InteractiveData.Core (class IDHtml)
import InteractiveData.Core.Classes.OptArgs (class OptArgs, getAllArgs)
import InteractiveData.Core.Types.Common (PathInContext)
import InteractiveData.Core.Types.DataPathExtra (segmentToString)
import Chameleon as VD

type ViewDataLabelCfg =
  { dataPath :: PathInContext DataPathSegment
  , mkTitle :: PathInContext DataPathSegment -> String
  }

mkTitleGoto :: PathInContext DataPathSegment -> String
mkTitleGoto dataPath =
  let
    isAbsolute :: Boolean
    isAbsolute = Array.length dataPath.before == 0

    pathStr :: String
    pathStr =
      if isAbsolute then "/" <> printDataPath dataPath.path
      else "./" <> printDataPath dataPath.path
  in
    "Go to: " <> pathStr

mkTitleSelect :: PathInContext DataPathSegment -> String
mkTitleSelect dataPath =
  let

    maybeTitle :: Maybe String
    maybeTitle = do
      segment :: DataPathSegment <- Array.last dataPath.path

      caseName <- case segment of
        SegCase caseName -> Just caseName
        _ -> Nothing

      pure $ "Select: " <> caseName

  in
    fromMaybe "" maybeTitle

type ViewDataLabelOpt msg =
  { onHit :: Maybe msg
  , isSelected :: Boolean
  , size :: Size
  }

---

data Size = Small | Medium | Large

viewDataLabel' :: forall html msg. IDHtml html => ViewDataLabelCfg -> ViewDataLabelOpt msg -> html msg
viewDataLabel' { dataPath, mkTitle } { onHit, isSelected } = withCtx \ctx ->
  let
    el =
      { datalabel:
          styleNode VD.div
            $
              [ "border: 1px solid rgb(232,232,232)"
              , "display: inline-flex"
              , "flex-direction: row"
              , "align-items: center"
              , "gap: 2px"
              , "padding-top: 1px"
              , "padding-bottom: 1px"
              , "padding-left: 3px"
              , "padding-right: 3px"
              , "border-radius: 2px"
              ]
            /\
              declWith ":hover" case onHit of
                Nothing -> []
                Just _ ->
                  [ "background-color: #d5ebdb" ]
            /\
              decl case onHit of
                Nothing -> []
                Just _ ->
                  [ "cursor: pointer"
                  , "background-color: #e1ffe9"
                  ]
            /\ declWith " > svg"
              [ "width:10px"
              , "height:10px"
              , "display:inline-block"
              ]
      }

    maybeSegment :: Maybe DataPathSegment
    maybeSegment = Array.last dataPath.path

    rootLabel :: String
    rootLabel = fst ctx.root

    label :: String
    label =
      case maybeSegment of
        Just segment -> segmentToString segment
        Nothing -> rootLabel

    icon :: html msg
    icon = case maybeSegment of
      Just (SegCase _) | isSelected -> UI.Assets.viewDiamondFilled
      Just (SegCase _) -> UI.Assets.viewDiamond
      Just (SegField _) -> UI.Assets.viewLabel
      Nothing -> UI.Assets.viewHome

    title' :: String
    title' = mkTitle dataPath

  in

    el.datalabel
      [ maybe VD.noProp (\_ -> VD.title title') onHit
      , maybe VD.noProp VD.onClick onHit
      ]
      [ icon
      , VD.span_ [ VD.text label ]
      ]

viewDataLabel
  :: forall opt html msg. OptArgs (ViewDataLabelOpt msg) opt => IDHtml html => ViewDataLabelCfg -> opt -> html msg
viewDataLabel cfg = getAllArgs defaults >>> viewDataLabel' cfg
  where

  defaults :: ViewDataLabelOpt msg
  defaults =
    { onHit: Nothing
    , isSelected: false
    , size: Medium

    }

printDataPath :: DataPath -> String
printDataPath segments = Str.joinWith "/" $ map segmentToString segments