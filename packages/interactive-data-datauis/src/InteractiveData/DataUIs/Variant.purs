module InteractiveData.DataUIs.Variant
  ( variant_
  , module Export
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Data.Array as Array
import Data.Newtype as NT
import Data.Variant (Variant)
import DataMVC.Variant.DataUI (class DataUiVariant)
import DataMVC.Variant.DataUI as V
import InteractiveData.App.UI.DataLabel as UIDataLabel
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.Core.Types.IDSurface (runIdSurface)
import MVC.Variant (CaseKey(..), VariantMsg, VariantState, ViewArgs)
import MVC.Variant (VariantMsg, VariantState) as Export
import Partial.Unsafe (unsafePartial)
import Type.Proxy (Proxy(..))

view :: forall html msg. IDHtml html => ViewArgs html msg -> html msg
view { viewCase, mkMsg, caseKey, caseKeys } =
  withCtx \ctx ->
    let
      newSeg :: DataPathSegment
      newSeg = SegCase $ NT.un CaseKey caseKey

      newPath :: DataPath
      newPath = ctx.path <> [ newSeg ]

      countCases :: Int
      countCases = Array.length caseKeys

      singleCase :: Boolean
      singleCase = countCases == 1

      el =
        { caseLabels: styleNode C.div
            [ "display: flex"
            , "flex-direction: column"
            , case ctx.viewMode of
                Inline -> "flex-direction: column"
                Standalone -> "flex-direction: row"
            , "gap: 5px"
            , "margin-bottom: 15px"
            ]
        , caseLabel: C.div
        }

    in
      putCtx ctx { path = newPath } $
        C.div_
          [ el.caseLabels []
              ( caseKeys # map \possibleCaseKey ->
                  el.caseLabel []
                    [ UIDataLabel.view
                        { dataPath:
                            { before: []
                            , path: ctx.path <> [ SegCase $ NT.un CaseKey possibleCaseKey ]
                            }
                        , mkTitle: UIDataLabel.mkTitleSelect
                        }
                        { isSelected: possibleCaseKey == caseKey
                        , onHit: if singleCase then Nothing else Just $ mkMsg $ possibleCaseKey
                        }
                    ]
              )
          , case ctx.viewMode of
              Inline -> C.noHtml
              Standalone | not ctx.fastForward -> C.noHtml
              Standalone ->
                putCtx ctx
                  { path = newPath
                  , viewMode = Standalone
                  } $
                  viewCase
          ]

variant_
  :: forall datauis html @initsym rcase rmsg rsta r
   . DataUiVariant datauis WrapMsg WrapState (IDSurface html) initsym rcase rmsg rsta r
  => IDHtml html
  => Record datauis
  -> DataUI
       (IDSurface html)
       WrapMsg
       WrapState
       (VariantMsg rcase rmsg)
       (VariantState rsta)
       (Variant r)
variant_ dataUis =
  V.dataUiVariant
    dataUis
    (Proxy :: Proxy initsym)
    { view: \(opts :: ViewArgs (IDSurface html) _) ->
        IDSurface \(ctx :: IDSurfaceCtx) ->
          let
            opts' :: ViewArgs html _
            opts' = opts
              { viewCase = opts.viewCase
                  # runIdSurface ctx
                  # un DataTree
                  # _.view
              }

            children :: DataTreeChildren html _
            children = Case
              (un CaseKey opts.caseKey /\ runIdSurface ctx opts.viewCase)

          in
            DataTree
              { view: view opts'
              , children
              , actions: dataActions
                  { caseKey: opts.caseKey
                  , caseKeys: opts.caseKeys
                  , mkMsg: opts.mkMsg
                  }
              , meta: Nothing
              }

    }

indexMod :: forall a. Int -> Array a -> a
indexMod idx items =
  let
    length :: Int
    length = Array.length items

    indexSafe :: Int
    indexSafe = idx `mod` length
  in
    unsafePartial $ Array.unsafeIndex items indexSafe

dataActions
  :: forall msg
   . { caseKey :: CaseKey
     , caseKeys :: Array CaseKey
     , mkMsg :: CaseKey -> msg
     }
  -> Array (DataAction msg)
dataActions { caseKey, caseKeys, mkMsg } =
  let
    caseCount = Array.length caseKeys :: Int

    index :: Maybe Int
    index = Array.findIndex (_ == caseKey) caseKeys

    indexOr0 :: Int
    indexOr0 = fromMaybe 0 index

    nextIndex :: Int
    nextIndex = indexOr0 + 1

    prevIndex :: Int
    prevIndex = indexOr0 - 1

    nextCaseKey :: CaseKey
    nextCaseKey = indexMod nextIndex caseKeys

    prevCaseKey :: CaseKey
    prevCaseKey = indexMod prevIndex caseKeys

    nextMsg :: msg
    nextMsg = mkMsg $ indexMod nextIndex caseKeys

    prevMsg :: msg
    prevMsg = mkMsg $ indexMod prevIndex caseKeys
  in
    case caseCount of
      0 -> []
      1 -> []
      2 ->
        [ DataAction
            { label: "Toggle"
            , description: "Switch to " <> un CaseKey nextCaseKey
            , msg: This nextMsg
            }
        ]
      _ ->
        [ DataAction
            { label: "Prev"
            , description: "Switch to " <> un CaseKey prevCaseKey
            , msg: This prevMsg
            }
        , DataAction
            { label: "Next"
            , description: "Switch to " <> un CaseKey nextCaseKey
            , msg: This nextMsg
            }
        ]
