module Demo.Samples.Painting.Main
  ( main
  ) where

import Prelude

import Chameleon (class Html)
import Chameleon as C
import Chameleon.Impl.ReactBasic as RI
import Chameleon.Impl.ReactBasic.Html (ReactHtml, defaultConfig)
import Chameleon.SVG.Attributes as SA
import Chameleon.SVG.Elements as S
import Chameleon.Styled (class HtmlStyled, StyleT, runStyleT, styleNode)
import Data.Argonaut (Json, encodeJson)
import Data.Argonaut as JSON
import Data.Array (intercalate)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), maybe)
import Demo.Common.Features.Refinement.ArchiveID (archiveID, sampleArchiveID)
import Demo.Common.Features.Refinement.ArchiveID as ArchiveID
import Demo.Common.PaintingSample (Image, Meta, Painting, USD(..), printUSD)
import Effect (Effect)
import InteractiveData (DataUI')
import InteractiveData as ID
import InteractiveData.Entry (InteractiveDataApp)
import React.Basic.Hooks (JSX, (/\))
import React.Basic.Hooks as React

paintingDataUi :: DataUI' _ _ Painting
paintingDataUi = ID.record_
  { meta: ID.recordPartial
      { text: Just "Contains meta data about a painting"
      }
      { title: ID.maybe
          { text: Just "The title of the Painting, if existing"
          }
          { "Just": ID.string_
          , "Nothing": unit
          }
      , author: ID.maybe
          { text: Just "The author of the Painting, if known"
          }
          { "Just": ID.string_
          , "Nothing": unit
          }
      , year: ID.maybe
          { text: Just "The year the painting was created"
          }
          { "Just": ID.int
              { min: 1900
              , max: 3000
              }
          , "Nothing": unit
          }
      , archiveId: archiveID
          { text: Just "The ID of the painting in the archive. Only lowercase letters."
          }
      , keywords: ID.array
          { text: Just "A list of keywords describing the painting"
          }
          ID.string_
      , price: ID.newtype_ $ ID.int
          { min: 1900
          , max: 3000
          , text: Just "The price for the next auction"
          }
      }
  , image: ID.recordPartial
      { text: Just "The actual image data: Shapes and Colors"
      }
      { height: ID.number
          { text: Just "The height of the image"
          , min: 0.0
          , max: 100.0
          }
      , width: ID.number
          { text: Just "The width of the image"
          , min: 0.0
          , max: 100.0
          }
      }
  }

sampleApp :: forall html. Html html => InteractiveDataApp html _ _ Painting
sampleApp =
  ID.toApp
    { name: "Painting"
    , initData: Just initPainting
    , fullscreen: false
    , showLogo: true
    }
    paintingDataUi

reactComponent :: React.Component {}
reactComponent = do
  let
    { ui, extract } = sampleApp

  React.component "Root" \_props -> React.do

    state /\ setState <- React.useState $ ui.init

    let
      handler msg = do
        setState $ ui.update msg

      dataResult :: Either _ Painting
      dataResult = extract state

      mainView :: StyleT ReactHtml _
      mainView =
        view
          { atControls: ui.view state
          , atImage:
              case dataResult of
                Left errors -> Left
                  { atError: C.text $ show errors }
                Right data_ -> Right
                  { atJson: viewJson (encodeJson data_)
                  , atPicture: viewPainting
                      { atMeta: viewMeta data_.meta
                      , atImage: viewImage data_.image
                      }
                      data_
                  }
          }

      jsx :: JSX
      jsx = RI.runReactHtml { handler } defaultConfig $ runStyleT mainView

    pure jsx

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
      -- , frame: 0.0
      -- , background: Color { red: 0, green: 0, blue: 0 }
      -- , shapes: []
      }
  }

---

viewImage :: forall html msg. HtmlStyled html => Image -> html msg
viewImage { width, height } =
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
          [ SA.width $ show width <> "px"
          , SA.height $ show height <> "px"
          , C.style "border: 1px solid black"
          ]
          []
      ]

view
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
view { atControls, atImage } =
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
          , "width: 800px"
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
      , row: styleNode C.tr
          [ ""
          ]
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

---

main :: Effect Unit
main = RI.mountAtId "root" reactComponent
