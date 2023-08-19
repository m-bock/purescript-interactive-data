module Demo.Samples.Painting.Main
  ( main
  ) where

import Prelude

import Chameleon as C
import Chameleon.Impl.ReactBasic as RI
import Chameleon.Impl.ReactBasic.Html (ReactHtml, defaultConfig)
import Chameleon.Styled (class HtmlStyled, runStyleT, styleNode)
import Data.Argonaut (Json, encodeJson)
import Data.Argonaut as JSON
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Demo.Common.PaintingSample (Image, Meta, Painting)
import Effect (Effect)
import InteractiveData as ID
import InteractiveData.Entry (InteractiveDataApp)
import React.Basic.Hooks (JSX, (/\))
import React.Basic.Hooks as React

sampleApp :: InteractiveDataApp ReactHtml _ _ Painting
sampleApp =
  ID.toApp
    { name: "Sample"
    , initData: Just initPainting
    , fullscreen: false
    , showLogo: true
    }
    ID.dataUi

reactComponent :: React.Component {}
reactComponent = do
  let
    { ui, extract } = sampleApp

  React.component "Root" \_props -> React.do

    state /\ setState <- React.useState $ ui.init

    let
      handler msg = do
        setState $ ui.update msg

      mainView :: forall html msg. HtmlStyled html => html msg
      mainView =
        view
          { atControls: C.text "controls"
          , atImage: case extract state of
              Left errors -> Left
                { atError: C.text $ show errors }
              Right st -> Right
                { atJson: viewJson (encodeJson st)
                , atPicture: viewPainting
                    { atMeta: viewMeta st.meta
                    , atImage: viewImage st.image
                    }
                    st
                }
          }

      jsx2 :: JSX
      jsx2 = RI.runReactHtml { handler } defaultConfig $ runStyleT mainView

    pure jsx2

initPainting :: Painting
initPainting =
  { meta:
      { title: Nothing
      -- , author: Nothing
      -- , year: Just 2023
      -- , archiveId: ArchiveID "0"
      -- , keywords: [ "Foo", "Bar", "Baz" ]
      -- , price: USD 0.0
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
viewImage {} =
  let
    el =
      { root: styleNode C.div
          [ "" ]
      }
  in
    el.root []
      [ C.text "image" ]

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
view { atImage } =
  let
    el =
      { root: styleNode C.div
          [ "display: grid"
          , "position: fixed"
          , "top: 0"
          , "left: 0"
          , "width: 100%"
          , "height: 100%"
          ]
      , tiles: styleNode C.div
          [ "display: grid"
          , "grid-template-columns: 1fr 1fr 1fr"
          , "grid-template-rows: 1fr 1fr 1fr 1fr"
          , "gap: 10px"
          , "height: 600px"
          , "width: 800px"
          , "place-self: center"
          ]
      , itemControls: styleNode C.div
          [ "background-color: #eee"
          , "border: 1px solid #333"
          , "padding: 10px"
          , "grid-column: 1 / 4"
          , "grid-row: 1 / 3"
          ]
      , itemPicture: styleNode C.div
          [ "background-color: #eee"
          , "border: 1px solid #333"
          , "padding: 10px"
          , "grid-column: 1 / 3"
          , "grid-row: 3 / 5"
          , "border-radius: 5px"
          ]
      , itemJson: styleNode C.div
          [ "background-color: #eee"
          , "border: 1px solid #333"
          , "padding: 10px"
          , "grid-column: 3 / 4"
          , "grid-row: 3 / 5"
          , "border-radius: 5px"
          ]
      }
  in
    el.root []
      [ el.tiles [] $
          [ el.itemControls []
              [ C.text "control" ]

          ] <>
            case atImage of
              Left {} -> []
              Right { atJson, atPicture } ->
                [ el.itemPicture []
                    [ atPicture ]
                , el.itemJson []
                    [ atJson ]
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
          , "grid-template-columns: 1fr 1fr"
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
viewMeta {} =
  let
    el =
      { root: styleNode C.div
          [ "background-color: #eee"
          , "height: 100%"
          ]
      , table: styleNode C.table
          [ "width: 100%"
          , "border-collapse: collapse"
          , "height: 100%"
          ]
      , row: styleNode C.tr
          [ "" ]
      , cellKey: styleNode C.td
          [ "padding: 5px"
          , "border: 1px solid #333"
          , "font-weight: bold"
          , "font-family: Arial"
          ]
      , cellValue: styleNode C.td
          [ "padding: 5px"
          , "border: 1px solid #333"
          , "width: 100%"
          , "font-family: Arial"
          ]
      }

    viewEntry :: { atKey :: html msg, atValue :: html msg } -> html msg
    viewEntry { atKey, atValue } = el.row []
      [ el.cellKey [] [ atKey ]
      , el.cellValue [] [ atValue ]
      ]
  in
    el.root []
      [ el.table []
          [ viewEntry
              { atKey: C.text "Title"
              , atValue: C.text "X"
              }
          , viewEntry
              { atKey: C.text "Author"
              , atValue: C.text "X"
              }
          , viewEntry
              { atKey: C.text "Year"
              , atValue: C.text "X"
              }
          , viewEntry
              { atKey: C.text "ID"
              , atValue: C.text "X"
              }
          , viewEntry
              { atKey: C.text "Keywords"
              , atValue: C.text "X"
              }
          , viewEntry
              { atKey: C.text "Price"
              , atValue: C.text "X"
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
          ]
      , jsonStr: styleNode C.pre
          [ "font-size: 12px"
          , "font-family: monospace"
          ]
      }
  in

    el.root []
      [ el.jsonStr []
          [ C.text $ JSON.stringifyWithIndent 2 json
          ]
      ]

---

main :: Effect Unit
main = RI.mountAtId "root" reactComponent
