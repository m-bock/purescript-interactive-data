module InteractiveData.DataUIs.Record
  ( mkSegmentStatic
  , mkSurface
  , module Export
  , record'
  , record_
  ) where

import Prelude

import Chameleon as VD
import Chameleon.Styled (styleNode)
import Chameleon.Transformers.Ctx.Class (putCtx, withCtx)
import Data.Array (mapWithIndex)
import Data.Array as Array
import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Data.Tuple.Nested (type (/\), (/\))
import DataMVC.Record.DataUI (class DataUiRecord)
import DataMVC.Record.DataUI as R
import DataMVC.Types (DataPathSegment(..), DataPathSegmentField(..), DataUI)
import InteractiveData.App.FastForward.Inline (viewFastForwardInline)
import InteractiveData.Core (class IDHtml, DataTree(..), DataTreeChildren(..), IDSurface(..), ViewMode(..))
import InteractiveData.Core.Types.DataTree as DT
import InteractiveData.Core.Types.IDSurface (runIdSurface)
import MVC.Record (RecordMsg, RecordState) as Export
import MVC.Record (RecordMsg, RecordState, ViewResult)

type DataUiRecordCfg =
  { mkSegment :: Int -> String -> DataPathSegmentField
  }

newView
  :: forall html msg
   . IDHtml html
  => (Array (DataPathSegmentField /\ DataTree html msg))
  -> html msg
newView fields =
  withCtx \ctx ->
    let
      el =
        { fieldsCountInfo: styleNode VD.div
            [ "font-style: italic"
            , "font-size: 10px"
            , "color: #999"
            ]
        , root: styleNode VD.div
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
              [ VD.text countFieldsText ]
          ]
        else
          case ctx.viewMode of
            Inline ->
              [ el.fieldsCountInfo []
                  [ VD.text countFieldsText ]
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
viewRow index (seg /\ tree@(DataTree { view })) = withCtx \ctx ->
  let
    newPath = ctx.path <> [ SegField seg ]

    el =
      { root: VD.div
      }

    trivialTrees :: Array (Array DataPathSegment /\ DataTree html msg)
    trivialTrees = DT.digTrivialTrees
      newPath
      tree
  in
    el.root []
      [ putCtx ctx { path = newPath, viewMode = Inline } $
          viewFastForwardInline trivialTrees
      ]

mkSurface
  :: forall html msg
   . IDHtml html
  => { mkSegment :: Int -> String -> DataPathSegmentField }
  -> Array (ViewResult (IDSurface html) msg)
  -> IDSurface html msg
mkSurface { mkSegment } opts = IDSurface \ctx ->
  let
    opts' = map (\x -> x { viewValue = x.viewValue # runIdSurface ctx # un DataTree # _.view }) opts

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

    view :: html msg
    view = newView fields
  in
    DataTree
      { view
      -- recordViewEntries
      --   { viewRow: recordViewRow { mkSegment } }
      --   opts'
      , children
      , actions: []
      , meta: Nothing
      }

record'
  :: forall datauis html fm fs rmsg rsta r
   . DataUiRecord datauis fm fs (IDSurface html) rmsg rsta r
  => IDHtml html
  => DataUiRecordCfg
  -> Record datauis
  -> DataUI (IDSurface html) fm fs (RecordMsg rmsg) (RecordState rsta) (Record r)
record' { mkSegment } =
  R.dataUiRecord
    { viewEntries: mkSurface { mkSegment }
    }

record_
  :: forall datauis html fm fs rmsg rsta r
   . DataUiRecord datauis fm fs (IDSurface html) rmsg rsta r
  => IDHtml html
  => Record datauis
  -> DataUI (IDSurface html) fm fs (RecordMsg rmsg) (RecordState rsta) (Record r)
record_ = record'
  { mkSegment: mkSegmentStatic
  }

mkSegmentStatic :: Int -> String -> DataPathSegmentField
mkSegmentStatic _ = SegStaticKey

type Opts' :: forall k. (k -> Type) -> k -> Type
type Opts' html msg = Array
  { key :: String
  , viewValue :: html msg
  }

type Opt' :: forall k. (k -> Type) -> k -> Type
type Opt' html msg =
  { key :: String
  , viewValue :: html msg
  }
