module Demo.Common.Embedded
  ( sampleApp
  , view
  ) where

import Prelude

import Chameleon (class Html)
import Chameleon as C
import Chameleon.SVG.Attributes as SA
import Chameleon.SVG.Elements as S
import Chameleon.Styled (class HtmlStyled, decl, declWith, styleNode)
import Data.Argonaut (Json, encodeJson)
import Data.Argonaut as JSON
import Data.Array (intercalate)
import Data.Array as Array
import Data.Either (Either(..))
import Data.Interpolate (i)
import Data.Maybe (Maybe(..), maybe)
import Data.Number (cos, pi, sin)
import Data.String as Str
import Demo.Samples.PaintingApp.ArchiveID (sampleArchiveID)
import Demo.Samples.PaintingApp.ArchiveID as ArchiveID
import Demo.Samples.PaintingApp.Color (Color(..))
import Demo.Samples.PaintingApp.Color as Color
import Demo.Samples.PaintingApp.DataUIs (paintingDataUi)
import Demo.Samples.PaintingApp.Types (Image, Meta, Painting, Shape(..), USD(..), printUSD)
import InteractiveData (DataResult)
import InteractiveData as ID
import InteractiveData.Entry (InteractiveDataApp)

sampleApp :: forall html. Html html => InteractiveDataApp html _ _ Painting
sampleApp =
  ID.toApp
    { name: "Painting"
    , initData: Just initPainting
    , fullscreen: false
    , showLogo: true
    }
    paintingDataUi

initPainting :: Painting
initPainting =
  { meta:
      { title: Nothing
      , author: Nothing
      , year: Just 2023
      , archiveId: sampleArchiveID
      , keywords: [ "Abstract", "Geometric", "Colorful" ]
      , price: USD 0
      }
  , image:
      { width: 100.0
      , height: 100.0
      , frame: 3.0
      , background: Color { red: 200, green: 200, blue: 200 }
      , shapes:
          [ Triangle
              { x: 41.0
              , y: 71.0
              , radius: 36.0
              , rotation: 81.0
              , color: Color { red: 195, green: 255, blue: 56 }
              , outline: false
              }

          , Rect
              { x: 56.0
              , y: 20.0
              , width: 53.0
              , height: 62.0
              , rotation: 242.0
              , color: Color { red: 68, green: 176, blue: 213 }
              , outline: false
              }

          , Circle
              { x: 31.0
              , y: 33.0
              , radius: 36.0
              , color: Color { red: 226, green: 75, blue: 75 }
              , outline: false
              }
          ]
      }
  }

--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------

view
  :: forall html msg
   . HtmlStyled html
  => { viewInteractiveData :: html msg }
  -> DataResult Painting
  -> html msg
view { viewInteractiveData } dataResult =
  viewRoot
    { atControls: viewInteractiveData
    , atImage:
        case dataResult of
          Left errors -> Left
            { atError: C.text $ show errors }
          Right data_ -> Right
            { atJson: viewJson (encodeJson data_)
            , atPicture:
                viewPainting
                  { atMeta: viewMeta data_.meta
                  , atImage:
                      viewImage
                        { atShape: viewShape }
                        data_.image
                  }
                  data_
            }
    }

viewImage
  :: forall html msg
   . HtmlStyled html
  => { atShape :: Shape -> html msg
     }
  -> Image
  -> html msg
viewImage { atShape } { width, height, background, frame, shapes } =
  let
    el =
      { root: styleNode C.div
          [ "display: grid"
          , "place-items: center"
          , "width: 100%"
          , "height: 100%"
          ]
      }
  in
    el.root []
      [ S.svg
          [ SA.width $ i width "px"
          , SA.height $ i height "px"
          ]
          ( [ S.rect
                [ SA.fill $ Color.toHex background
                , SA.width "100%"
                , SA.height "100%"
                ]
            ] <> map atShape (Array.reverse shapes) <>
              [ S.rect
                  [ SA.width "100%"
                  , SA.height "100%"
                  , SA.stroke "#996633"
                  , SA.fill "none"
                  , SA.strokeWidth $ i frame "px"
                  ]
              ]
          )
      ]

viewShape
  :: forall html msg
   . HtmlStyled html
  => Shape
  -> html msg
viewShape = case _ of
  Circle { x, y, radius, color, outline } ->
    S.circle
      [ SA.cx $ i x "px"
      , SA.cy $ i y "px"
      , SA.r $ i radius "px"
      , SA.fill $ Color.toHex color
      , SA.stroke "black"
      , SA.strokeWidth if outline then "1px" else "0px"
      ]

  Rect { x, y, width, height, color, outline, rotation } ->
    let
      centerX = x + width / 2.0
      centerY = y + height / 2.0
    in
      S.rect
        [ SA.x $ i x "px"
        , SA.y $ i y "px"
        , SA.width $ i width "px"
        , SA.height $ i height "px"
        , SA.transform $ i "rotate(" rotation " " centerX " " centerY ")"
        , SA.fill $ Color.toHex color
        , SA.stroke "black"
        , SA.strokeWidth if outline then "1px" else "0px"
        ]

  Triangle { x, y, radius, rotation, color, outline } ->
    let
      pointAx = x
      pointAy = y - radius

      pointBx = x - radius * cos (pi / 6.0)
      pointBy = y + radius * sin (pi / 6.0)

      pointCx = x + radius * cos (pi / 6.0)
      pointCy = y + radius * sin (pi / 6.0)

    in
      S.polygon
        [ SA.points $ Str.joinWith ","
            [ i pointAx " " pointAy
            , i pointBx " " pointBy
            , i pointCx " " pointCy
            ]
        , SA.transform $ i "rotate(" rotation "," x "," y ")"
        , SA.fill $ Color.toHex color
        , SA.stroke "black"
        , SA.strokeWidth if outline then "1px" else "0px"
        ]

viewRoot
  :: forall html msg
   . HtmlStyled html
  => { atImage ::
         Either
           { atError :: html msg }
           { atJson :: html msg
           , atPicture :: html msg
           }
     , atControls ::
         html msg
     }
  -> html msg
viewRoot { atControls, atImage } =
  let
    el =
      { root: styleNode C.div
          [ "display: grid"
          , "position: fixed"
          , "top: 0"
          , "left: 0"
          , "width: 100%"
          , "height: 100%"
          , "background-color: rgb(49 50 55)"
          ]
      , tiles: styleNode C.div
          [ "display: grid"
          , "grid-template-columns: minmax(0, 1fr) minmax(0, 1fr) minmax(0, 1fr)"
          , "grid-template-rows: 1fr 1fr 1fr 1fr 1fr 1fr"
          , "gap: 60px 30px"
          , "height: 800px"
          , "max-width: 800px"
          , "place-self: center"
          ]
      , itemControls: styleNode C.div
          [ "background-color: #eee"
          , "border: 1px solid #333"
          , "grid-column: 1 / 4"
          , "grid-row: 1 / 5"
          , "position: relative"
          ]
      , itemPicture: styleNode C.div
          [ "background-color: #eee"
          , "border: 1px solid #333"
          , "padding: 10px"
          , "grid-column: 1 / 3"
          , "grid-row: 5 / 7"
          , "border-radius: 5px"
          , "position: relative"
          ]
      , itemJson: styleNode C.div
          [ "background-color: #eee"
          , "border: 1px solid #333"
          , "padding: 10px"
          , "grid-column: 3 / 4"
          , "grid-row: 5 / 7"
          , "border-radius: 5px"
          , "position: relative"
          ]
      , label: styleNode C.div
          [ "font-size: 12px"
          , "color: #333"
          , "position: absolute"
          , "top: -20"
          , "left: 0"
          , "color: white"
          ]
      , linkSection: styleNode C.div
          [ "position: fixed"
          , "top: 0"
          , "right: 0"
          , "padding: 10px"
          , "font-size: 12px"
          , "color: white"
          ]
      , link: styleNode C.a
          [ declWith ":link" [ "text-decoration : none" ]
          , declWith ":visited" [ "text-decoration : none" ]
          , declWith ":hover" [ "text-decoration : none" ]
          , declWith ":active" [ "text-decoration : none" ]
          , decl
              [ "color : white"
              , "font-size : 12px"
              , "font-family : sans-serif"
              ]
          ]
      }
  in
    el.root []
      [ el.tiles [] $
          [ el.itemControls []
              [ el.label []
                  [ C.text "Embedded interactive-data UI" ]
              , atControls
              ]

          ] <>
            case atImage of
              Left {} -> []
              Right { atJson, atPicture } ->
                [ el.itemPicture []
                    [ el.label []
                        [ C.text "Sample data rendering" ]
                    , atPicture
                    ]
                , el.itemJson []
                    [ el.label []
                        [ C.text "JSON encoded data" ]
                    , atJson
                    ]
                ]
      , el.linkSection []
          [ el.link [ C.href "https://github.com/thought2/purescript-interactive-data" ]
              [ C.text "Github" ]
          , C.text " | "
          , el.link [ C.href "https://thought2.github.io/purescript-interactive-data/manual/" ]
              [ C.text "Manual" ]
          ]
      ]

viewPainting
  :: forall html msg
   . HtmlStyled html
  => { atMeta :: html msg
     , atImage :: html msg
     }
  -> Painting
  -> html msg
viewPainting { atMeta, atImage } {} =
  let
    el =
      { root: styleNode C.div
          [ "display: grid"
          , "grid-template-columns: minmax(0, 2fr) minmax(0, 1fr)"
          , "grid-template-rows: 1fr"
          , "gap: 10px"
          , "height: 100%"
          , "width: 100%"
          ]
      , itemMeta: styleNode C.div
          [ "background-color: #eee"
          , "grid-column: 1 / 2"
          , "grid-row: 1 / 2"
          ]
      , itemImage: styleNode C.div
          [ "background-color: #eee"
          , "border: 1px solid #333"
          , "padding: 10px"
          , "grid-column: 2 / 3"
          , "grid-row: 1 / 2"
          ]
      }
  in
    el.root []
      [ el.itemMeta []
          [ atMeta ]
      , el.itemImage []
          [ atImage ]
      ]

viewMeta :: forall html msg. HtmlStyled html => Meta -> html msg
viewMeta { author, title, year, archiveId, keywords, price } =
  let
    el =
      { root: styleNode C.div
          [ "background-color: #eee"
          ]
      , table: styleNode C.table
          [ "width: 100%"
          , "border-collapse: collapse"
          , "height: 100%"
          , "table-layout: fixed"
          ]
      , row: C.tr
      , cellKey: styleNode C.td
          [ "padding-left: 10px"
          , "padding-right: 20px"
          , "border: 1px solid #333"
          , "font-size: 13px"
          , "font-weight: bold"
          , "font-family: Arial"
          , "width: 70px"
          ]
      , cellValue: styleNode C.td
          [ "padding-left: 10px"
          , "padding-right: 10px"
          , "border: 1px solid #333"
          , "font-size: 13px"
          , "font-family: Arial"
          , "overflow: hidden"
          , "white-space: nowrap"
          , "text-overflow: ellipsis"
          ]
      , notAvailable: styleNode C.div
          [ "color: #999"
          ]
      }

    viewEntry :: { atKey :: html msg, atValue :: html msg } -> html msg
    viewEntry { atKey, atValue } =
      el.row []
        [ el.cellKey [] [ atKey ]
        , el.cellValue [] [ atValue ]
        ]

    viewNotAvailable :: html msg
    viewNotAvailable =
      el.notAvailable []
        [ C.text "N/A" ]

  in
    el.root []
      [ el.table []
          [ viewEntry
              { atKey: C.text "Title"
              , atValue: maybe viewNotAvailable C.text title
              }
          , viewEntry
              { atKey: C.text "Author"
              , atValue: maybe viewNotAvailable C.text author
              }
          , viewEntry
              { atKey: C.text "Year"
              , atValue: maybe viewNotAvailable (show >>> C.text) year
              }
          , viewEntry
              { atKey: C.text "ID"
              , atValue: C.text ("#" <> ArchiveID.print archiveId)
              }
          , viewEntry
              { atKey: C.text "Keywords"
              , atValue: C.text (intercalate ", " keywords)
              }
          , viewEntry
              { atKey: C.text "Price"
              , atValue: C.text $ printUSD price
              }
          ]
      ]

viewJson :: forall html msg. HtmlStyled html => Json -> html msg
viewJson json =
  let
    el =
      { root: styleNode C.div
          [ "background-color: #eee"
          , "border: 1px solid #333"
          , "padding: 10px"
          , "height: 100%"
          , "box-sizing: border-box"
          , "overflow: auto"
          ]
      , pre: styleNode C.pre
          [ "margin: 0"
          ]
      , jsonStr: styleNode C.code
          [ "font-size: 10px"
          , "font-family: monospace"
          , "margin: 0"
          ]
      }

    jsonStr :: String
    jsonStr = JSON.stringifyWithIndent 2 json
  in
    el.root []
      [ el.pre []
          [ el.jsonStr []
              [ C.text $ jsonStr
              ]
          ]
      ]