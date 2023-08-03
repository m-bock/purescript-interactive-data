module InteractiveData.DataUIs.Record
  ( mkSegmentStatic
  , mkSurface
  , module Export
  , record'
  , record_
  )
  where

import Prelude

import Data.Array (mapWithIndex)
import Data.Array as Array
import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Data.Tuple.Nested ((/\))
import DataMVC.Record.DataUI (class DataUiRecord)
import DataMVC.Record.DataUI as R
import DataMVC.Types (DataPathSegment(..), DataPathSegmentField(..), DataUI)
import InteractiveData.Core (class IDHtml, DataTree(..), DataTreeChildren(..), IDSurface(..), ViewMode(..))
import InteractiveData.Core.Types.IDDataUI (runIdSurface)
import MVC.Record (RecordMsg, RecordState) as Export
import MVC.Record (RecordMsg, RecordState, ViewResult)
import Chameleon as VD
import Chameleon.Styled (styleNode)
import Chameleon.Transformers.Ctx.Class (putCtx, withCtx)

recordViewEntries
  :: forall html msg
   . IDHtml html
  => { viewRow :: Int -> ViewResult html msg -> html msg }
  -> Array (ViewResult html msg)
  -> html msg
recordViewEntries { viewRow } entries =
  withCtx \ctx ->
    let
      el =
        { noFields: styleNode VD.div
            [ "font-style: italic"
            , "font-size: 10px"
            , "color: #999"
            ]
        }

    in
      if Array.null entries then
        el.noFields []
          [ VD.text "no fields" ]
      else
        case ctx.viewMode of
          Inline -> VD.noHtml
          Standalone -> VD.div_
            (entries # mapWithIndex viewRow)

recordViewRow
  :: forall html msg
   . IDHtml html
  => { mkSegment :: Int -> String -> DataPathSegmentField }
  -> Int
  -> ViewResult html msg
  -> html msg
recordViewRow { mkSegment } index { key, viewValue } =
  withCtx \ctx ->
    let
      newSeg = SegField $ mkSegment index key
      newPath = ctx.path <> [ newSeg ]

      el =
        { root: styleNode VD.div "margin-bottom: 30px"
        }
    in
      putCtx ctx { path = newPath, viewMode = Inline } $
        el.root []
          [ viewValue ]

type DataUiRecordCfg =
  { mkSegment :: Int -> String -> DataPathSegmentField
  }

mkSurface
  :: forall html msg
   . IDHtml html
  => { mkSegment :: Int -> String -> DataPathSegmentField }
  -> Array (ViewResult (IDSurface html) msg)
  -> IDSurface html msg
mkSurface { mkSegment } opts = IDSurface \ctx ->
  let
    opts' = map (\x -> x { viewValue = x.viewValue # runIdSurface ctx # un DataTree # _.view }) opts

    children :: DataTreeChildren html msg
    children = Fields
      ( opts # mapWithIndex
          ( \ix x ->
              let
                newCtx = ctx { path = ctx.path <> [ SegField $ SegStaticKey x.key ] }
              in
                mkSegment ix x.key /\
                  runIdSurface newCtx x.viewValue
          )
      )
  in
    DataTree
      { view:
          recordViewEntries
            { viewRow: recordViewRow { mkSegment } }
            opts'
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
