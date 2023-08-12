module InteractiveData.DataUIs.Record
  ( CfgRecord
  , mkSegmentStatic
  , mkSurface
  , module Export
  , record
  , record_
  ) where

import InteractiveData.Core.Prelude

import Chameleon as C
import Data.Array (mapWithIndex)
import Data.Array as Array
import DataMVC.Record.DataUI (class DataUiRecord)
import DataMVC.Record.DataUI as R
import InteractiveData.App.FastForward.Inline as FastForwardInline
import InteractiveData.Core.Types.DataTree as DT
import InteractiveData.Core.Types.IDSurface (runIdSurface)
import MVC.Record (RecordMsg, RecordState) as Export
import MVC.Record (RecordMsg, RecordState, ViewResult)

view
  :: forall html msg
   . IDHtml html
  => (Array (DataPathSegmentField /\ DataTree html msg))
  -> html msg
view fields =
  withCtx \ctx ->
    let
      el =
        { fieldsCountInfo: styleNode C.div
            [ "font-style: italic"
            , "font-size: 10px"
            , "color: #999"
            ]
        , root: styleNode C.div
            [ "display: flex"
            , "gap: 20px"
            , "flex-direction: column"
            ]
        }

      countFieldsText :: String
      countFieldsText = case Array.length fields of
        0 -> "no fields"
        1 -> "1 field"
        n -> show n <> " fields"
    in
      el.root []
        if Array.null fields then
          [ el.fieldsCountInfo []
              [ C.text countFieldsText ]
          ]
        else
          case ctx.viewMode of
            Inline ->
              [ el.fieldsCountInfo []
                  [ C.text countFieldsText ]
              ]
            Standalone | not ctx.fastForward -> []
            Standalone ->
              (fields # mapWithIndex viewRow)

viewRow
  :: forall html msg
   . IDHtml html
  => Int
  -> (DataPathSegmentField /\ DataTree html msg)
  -> html msg
viewRow _ (seg /\ tree) = withCtx \ctx ->
  let
    newPath = ctx.path <> [ SegField seg ]

    el =
      { root: C.div
      }

    trivialTrees :: Array (Array DataPathSegment /\ DataTree html msg)
    trivialTrees = DT.digTrivialTrees
      newPath
      tree
  in
    el.root []
      [ putCtx ctx { path = newPath, viewMode = Inline } $
          FastForwardInline.view trivialTrees
      ]

mkSurface
  :: forall html msg
   . IDHtml html
  => { text :: Maybe String
     , mkSegment :: Int -> String -> DataPathSegmentField
     }
  -> Array (ViewResult (IDSurface html) msg)
  -> IDSurface html msg
mkSurface { mkSegment, text } opts = IDSurface \ctx ->
  let
    fields :: Array (DataPathSegmentField /\ DataTree html msg)
    fields = opts # mapWithIndex
      ( \ix x ->
          let
            newCtx = ctx { path = ctx.path <> [ SegField $ SegStaticKey x.key ] }
          in
            mkSegment ix x.key /\
              runIdSurface newCtx x.viewValue
      )

    children :: DataTreeChildren html msg
    children = Fields fields

  in
    DataTree
      { view: view fields
      , children
      , actions: []
      , meta: Nothing
      , text
      }

type CfgRecord =
  { text :: Maybe String
  , mkSegment :: Int -> String -> DataPathSegmentField
  }

defaultCfgRecord :: CfgRecord
defaultCfgRecord =
  { text: Nothing
  , mkSegment: mkSegmentStatic
  }

record
  :: forall opt datauis html fm fs rmsg rsta r
   . DataUiRecord datauis fm fs (IDSurface html) rmsg rsta r
  => IDHtml html
  => OptArgs CfgRecord opt
  => opt
  -> Record datauis
  -> DataUI (IDSurface html) fm fs (RecordMsg rmsg) (RecordState rsta) (Record r)
record opt =
  let
    cfg :: CfgRecord
    cfg = getAllArgs defaultCfgRecord opt
  in
    R.dataUiRecord
      { viewEntries: mkSurface
          { mkSegment: cfg.mkSegment
          , text: cfg.text
          }
      }

record_
  :: forall datauis html fm fs rmsg rsta r
   . DataUiRecord datauis fm fs (IDSurface html) rmsg rsta r
  => IDHtml html
  => Record datauis
  -> DataUI (IDSurface html) fm fs (RecordMsg rmsg) (RecordState rsta) (Record r)
record_ = record {}

mkSegmentStatic :: Int -> String -> DataPathSegmentField
mkSegmentStatic _ = SegStaticKey

