module Landing.App.LogoAnim where

import Prelude

import Chameleon (class Html)
import Chameleon as C
import Chameleon.SVG.Elements as CS
import Data.Array ((!!))
import Data.Maybe (fromMaybe)
import Data.String as Str

view :: forall html msg. Html html => html msg
view =
  C.elem (C.ElemName "svg")
    [ C.attr "viewBox" "0 0 512 512"
    , C.attr "xmlns" "http://www.w3.org/2000/svg"
    , C.attr "style" "fill:none;stroke-linecap:round;stroke-linejoin:round;stroke-width:20px;"
    ]
    [ C.elem (C.ElemName "g") [ C.attr "data-name" "Layer 2", C.attr "id" "Layer_2" ]
        [ C.elem (C.ElemName "g")
            [ C.attr "data-name" "E428, Control, media, multimedia, player, stop"
            , C.attr "id" "E428_Control_media_multimedia_player_stop"
            ]
            [ C.elem (C.ElemName "rect")
                [ C.attr "height" "492"
                , C.attr "rx" "50.2"
                , C.attr "width" "492"
                , C.attr "x" "10"
                , C.attr "y" "10"
                ]
                []
            , viewControl { x: 87.59, ys: [ 0.25, 0.6, 0.25, 0.25, 0.25, 0.25 ] }
            , viewControl { x: 199.86, ys: [ 0.7, 0.7, 0.1, 0.7, 0.7, 0.7 ] }
            , viewControl { x: 312.14, ys: [ 0.3, 0.3, 0.3, 0.7, 0.3, 0.3 ] }
            , viewControl { x: 424.41, ys: [ 0.55, 0.55, 0.55, 0.55, 0.92, 0.55 ] }
            ]
        ]
    ]

viewControl :: forall html msg. Html html => { x :: Number, ys :: Array Number } -> html msg
viewControl { x, ys } =
  let
    y1 = 120.33
    y2 = 391.67
    yDelta = y2 - y1
    r = 37.42
    yFirst = fromMaybe 0.0 $ ys !! 0
  in
    CS.g []
      [ (C.elem (C.ElemName "line"))
          [ C.attr "x1" (show x)
          , C.attr "x2" (show x)
          , C.attr "y1" (show y1)
          , C.attr "y2" (show y2)
          ]
          []

      , (C.elem (C.ElemName "circle"))
          [ C.attr "cx" (show x)
          , C.attr "cy" (show $ y1 + (1.0 - yFirst) * yDelta)
          , C.attr "r" (show r)
          , C.attr "fill" "white"
          ]
          [ C.elem (C.ElemName "animate")
              [ C.attr "attributeName" "cy"
              , C.attr "values"
                  (Str.joinWith ";" $ map (\y -> show $ y1 + (1.0 - y) * yDelta) ys)
              , C.attr "dur" "3s"
              , C.attr "fill" "freeze"
              , C.attr "keyTimes" "0; 0.2; 0.4; 0.6; 0.8; 1"
              , C.attr "calcMode" "spline"
              ]
              []
          ]

      ]