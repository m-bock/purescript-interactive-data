module InteractiveData.App.UI.Assets where

import Chameleon as C

viewSwitch :: forall html msg. C.Html html => html msg
viewSwitch =
  C.elem (C.ElemName "svg")
    [ C.attr "width" "800px"
    , C.attr "height" "800px"
    , C.attr "viewBox" "0 0 24 24"
    , C.attr "fill" "none"
    , C.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ C.elem (C.ElemName "path")
        [ C.attr "d" "M21 9L9 9"
        , C.attr "stroke" "#323232"
        , C.attr "stroke-width" "2"
        , C.attr "stroke-linecap" "round"
        , C.attr "stroke-linejoin" "round"
        ]
        []
    , C.elem (C.ElemName "path")
        [ C.attr "d" "M15 15L3 15"
        , C.attr "stroke" "#323232"
        , C.attr "stroke-width" "2"
        , C.attr "stroke-linecap" "round"
        , C.attr "stroke-linejoin" "round"
        ]
        []
    , C.elem (C.ElemName "path")
        [ C.attr "d" "M18 12L20.913 9.08704V9.08704C20.961 9.03897 20.961 8.96103 20.913 8.91296V8.91296L18 6"
        , C.attr "stroke" "#323232"
        , C.attr "stroke-width" "2"
        , C.attr "stroke-linecap" "round"
        , C.attr "stroke-linejoin" "round"
        ]
        []
    , C.elem (C.ElemName "path")
        [ C.attr "d" "M6 18L3.08704 15.087V15.087C3.03897 15.039 3.03897 14.961 3.08704 14.913V14.913L6 12"
        , C.attr "stroke" "#323232"
        , C.attr "stroke-width" "2"
        , C.attr "stroke-linecap" "round"
        , C.attr "stroke-linejoin" "round"
        ]
        []
    ]

viewPageNotFound :: forall html msg. C.Html html => html msg
viewPageNotFound =
  C.elem (C.ElemName "svg")
    [ C.attr "fill" "none", C.attr "xmlns" "http://www.w3.org/2000/svg", C.attr "viewBox" "38.15 62.11 73.28 86.01" ]
    [ C.elem (C.ElemName "path")
        [ C.attr "fill-rule" "evenodd"
        , C.attr "clip-rule" "evenodd"
        , C.attr "d"
            "M38.155 140.475L48.988 62.1108L92.869 67.0568L111.437 91.0118L103.396 148.121L38.155 140.475ZM84.013 94.0018L88.827 71.8068L54.046 68.3068L44.192 135.457L98.335 142.084L104.877 96.8088L84.013 94.0018ZM59.771 123.595C59.394 123.099 56.05 120.299 55.421 119.433C64.32 109.522 86.05 109.645 92.085 122.757C91.08 123.128 86.59 125.072 85.71 125.567C83.192 118.25 68.445 115.942 59.771 123.595ZM76.503 96.4988L72.837 99.2588L67.322 92.6168L59.815 96.6468L56.786 91.5778L63.615 88.1508L59.089 82.6988L64.589 79.0188L68.979 85.4578L76.798 81.5328L79.154 86.2638L72.107 90.0468L76.503 96.4988Z"
        , C.attr "fill" "#000000"
        ]
        []
    ]

viewLogo :: forall html msg. C.Html html => html msg
viewLogo =
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
                [ C.attr "class" "cls-1"
                , C.attr "height" "492"
                , C.attr "rx" "50.2"
                , C.attr "width" "492"
                , C.attr "x" "10"
                , C.attr "y" "10"
                ]
                []
            , C.elem (C.ElemName "line")
                [ C.attr "class" "cls-1"
                , C.attr "x1" "87.59"
                , C.attr "x2" "87.59"
                , C.attr "y1" "391.67"
                , C.attr "y2" "232.61"
                ]
                []
            , C.elem (C.ElemName "line")
                [ C.attr "class" "cls-1"
                , C.attr "x1" "87.59"
                , C.attr "x2" "87.59"
                , C.attr "y1" "157.76"
                , C.attr "y2" "120.33"
                ]
                []
            , C.elem (C.ElemName "circle")
                [ C.attr "class" "cls-1", C.attr "cx" "87.59", C.attr "cy" "195.18", C.attr "r" "37.42" ]
                []
            , C.elem (C.ElemName "line")
                [ C.attr "class" "cls-1"
                , C.attr "x1" "199.86"
                , C.attr "x2" "199.86"
                , C.attr "y1" "391.67"
                , C.attr "y2" "351.39"
                ]
                []
            , C.elem (C.ElemName "line")
                [ C.attr "class" "cls-1"
                , C.attr "x1" "199.86"
                , C.attr "x2" "199.86"
                , C.attr "y1" "276.54"
                , C.attr "y2" "120.33"
                ]
                []
            , C.elem (C.ElemName "circle")
                [ C.attr "class" "cls-1", C.attr "cx" "199.86", C.attr "cy" "313.96", C.attr "r" "37.42" ]
                []
            , C.elem (C.ElemName "line")
                [ C.attr "class" "cls-1"
                , C.attr "x1" "312.14"
                , C.attr "x2" "312.14"
                , C.attr "y1" "391.67"
                , C.attr "y2" "232.61"
                ]
                []
            , C.elem (C.ElemName "line")
                [ C.attr "class" "cls-1"
                , C.attr "x1" "312.14"
                , C.attr "x2" "312.14"
                , C.attr "y1" "157.76"
                , C.attr "y2" "120.33"
                ]
                []
            , C.elem (C.ElemName "circle")
                [ C.attr "class" "cls-1", C.attr "cx" "312.14", C.attr "cy" "195.18", C.attr "r" "37.42" ]
                []
            , C.elem (C.ElemName "line")
                [ C.attr "class" "cls-1"
                , C.attr "x1" "424.41"
                , C.attr "x2" "424.41"
                , C.attr "y1" "391.67"
                , C.attr "y2" "305.75"
                ]
                []
            , C.elem (C.ElemName "line")
                [ C.attr "class" "cls-1"
                , C.attr "x1" "424.41"
                , C.attr "x2" "424.41"
                , C.attr "y1" "230.9"
                , C.attr "y2" "120.33"
                ]
                []
            , C.elem (C.ElemName "circle")
                [ C.attr "class" "cls-1", C.attr "cx" "424.41", C.attr "cy" "268.32", C.attr "r" "37.42" ]
                []
            ]
        ]
    ]

viewLevelUp :: forall html msg. C.Html html => html msg
viewLevelUp =
  C.elem (C.ElemName "svg")
    [ C.attr "width" "800px"
    , C.attr "height" "800px"
    , C.attr "viewBox" "0 0 16 16"
    , C.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ C.elem (C.ElemName "path")
        [ C.attr "fill" "#000000"
        , C.attr "d"
            "M4.29289,4.297105 L8,0.59 L11.7071,4.297105 C12.0976,4.687635 12.0976,5.320795 11.7071,5.711315 C11.3166,6.101845 10.6834,6.101845 10.2929,5.711315 L9,4.418425 L9,11.004215 C9,11.004515 9,11.003915 9,11.004215 L9,12.004215 C9,12.556515 9.44772,13.004215 10,13.004215 L14,13.004215 C14.5523,13.004215 15,13.451915 15,14.004215 C15,14.556515 14.5523,15.004215 14,15.004215 L10,15.004215 C8.34315,15.004215 7,13.661115 7,12.004215 L7,4.418425 L5.70711,5.711315 C5.31658,6.101845 4.68342,6.101845 4.29289,5.711315 C3.90237,5.320795 3.90237,4.687635 4.29289,4.297105 Z"
        ]
        []
    ]

viewLabel :: forall html msg. C.Html html => html msg
viewLabel =
  C.elem (C.ElemName "svg")
    [ C.attr "fill" "#000000", C.attr "xmlns" "http://www.w3.org/2000/svg", C.attr "viewBox" "10 14 20 12" ]
    [ C.elem (C.ElemName "path") [ C.attr "d" "M25 14l5 6-5 6H10V14h15zm-1 2H12v8h12l3.5-4-3.5-4z" ] [] ]

viewHome :: forall html msg. C.Html html => html msg
viewHome =
  C.elem (C.ElemName "svg")
    [ C.attr "fill" "#000000"
    , C.attr "width" "800px"
    , C.attr "height" "800px"
    , C.attr "viewBox" "0 0 32 32"
    , C.attr "version" "1.1"
    , C.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ C.elem (C.ElemName "title") [] [ C.text "home" ]
    , C.elem (C.ElemName "path")
        [ C.attr "d"
            "M30.488 13.431l-14-12c-0.13-0.112-0.301-0.18-0.488-0.18s-0.358 0.068-0.489 0.181l0.001-0.001-14 12c-0.161 0.138-0.262 0.342-0.262 0.569v16c0 0.414 0.336 0.75 0.75 0.75h28c0.414-0 0.75-0.336 0.75-0.75v0-16c-0-0.227-0.101-0.431-0.261-0.569l-0.001-0.001zM11.75 29.25v-5.25c0-2.347 1.903-4.25 4.25-4.25s4.25 1.903 4.25 4.25v0 5.25zM29.25 29.25h-7.5v-5.25c0-3.176-2.574-5.75-5.75-5.75s-5.75 2.574-5.75 5.75v0 5.25h-7.5v-14.905l13.25-11.356 13.25 11.356z"
        ]
        []
    ]

viewExpandUp :: forall html msg. C.Html html => html msg
viewExpandUp =
  C.elem (C.ElemName "svg")
    [ C.attr "viewBox" "0 0 24 24", C.attr "fill" "none", C.attr "xmlns" "http://www.w3.org/2000/svg" ]
    [ C.elem (C.ElemName "path") [ C.attr "d" "M18 18L12 12L6 18", C.attr "stroke" "#222222" ] []
    , C.elem (C.ElemName "path") [ C.attr "d" "M18 12L12 6L6 12", C.attr "stroke" "#222222" ] []
    ]

viewExpandDown :: forall html msg. C.Html html => html msg
viewExpandDown =
  C.elem (C.ElemName "svg")
    [ C.attr "viewBox" "0 0 24 24", C.attr "fill" "none", C.attr "xmlns" "http://www.w3.org/2000/svg" ]
    [ C.elem (C.ElemName "path") [ C.attr "d" "M18 9L12 15L6 9", C.attr "stroke" "#222222" ] [] ]

viewDotMenuSolid :: forall html msg. C.Html html => html msg
viewDotMenuSolid =
  C.elem (C.ElemName "svg")
    [ C.attr "fill" "#000000"
    , C.attr "enable-background" "new 0 0 32 32"
    , C.attr "id" "Glyph"
    , C.attr "version" "1.1"
    , C.attr "xml:space" "preserve"
    , C.attr "xmlns" "http://www.w3.org/2000/svg"
    , C.attr "xmlns:xlink" "http://www.w3.org/1999/xlink"
    , C.attr "viewBox" "3 13 26 6"
    ]
    [ C.elem (C.ElemName "path")
        [ C.attr "d" "M16,13c-1.654,0-3,1.346-3,3s1.346,3,3,3s3-1.346,3-3S17.654,13,16,13z", C.attr "id" "XMLID_287_" ]
        []
    , C.elem (C.ElemName "path")
        [ C.attr "d" "M6,13c-1.654,0-3,1.346-3,3s1.346,3,3,3s3-1.346,3-3S7.654,13,6,13z", C.attr "id" "XMLID_289_" ]
        []
    , C.elem (C.ElemName "path")
        [ C.attr "d" "M26,13c-1.654,0-3,1.346-3,3s1.346,3,3,3s3-1.346,3-3S27.654,13,26,13z", C.attr "id" "XMLID_291_" ]
        []
    ]

viewDotMenu :: forall html msg. C.Html html => html msg
viewDotMenu =
  C.elem (C.ElemName "svg")
    [ C.attr "enable-background" "new 0 0 32 32"
    , C.attr "id" "Editable-line"
    , C.attr "version" "1.1"
    , C.attr "xml:space" "preserve"
    , C.attr "xmlns" "http://www.w3.org/2000/svg"
    , C.attr "xmlns:xlink" "http://www.w3.org/1999/xlink"
    , C.attr "viewBox" "3 13 26 6"
    ]
    [ C.elem (C.ElemName "circle")
        [ C.attr "cx" "16"
        , C.attr "cy" "16"
        , C.attr "fill" "none"
        , C.attr "id" "XMLID_878_"
        , C.attr "r" "2"
        , C.attr "stroke" "#000000"
        , C.attr "stroke-linecap" "round"
        , C.attr "stroke-linejoin" "round"
        , C.attr "stroke-miterlimit" "10"
        , C.attr "stroke-width" "2"
        ]
        []
    , C.elem (C.ElemName "circle")
        [ C.attr "cx" "6"
        , C.attr "cy" "16"
        , C.attr "fill" "none"
        , C.attr "id" "XMLID_879_"
        , C.attr "r" "2"
        , C.attr "stroke" "#000000"
        , C.attr "stroke-linecap" "round"
        , C.attr "stroke-linejoin" "round"
        , C.attr "stroke-miterlimit" "10"
        , C.attr "stroke-width" "2"
        ]
        []
    , C.elem (C.ElemName "circle")
        [ C.attr "cx" "26"
        , C.attr "cy" "16"
        , C.attr "fill" "none"
        , C.attr "id" "XMLID_880_"
        , C.attr "r" "2"
        , C.attr "stroke" "#000000"
        , C.attr "stroke-linecap" "round"
        , C.attr "stroke-linejoin" "round"
        , C.attr "stroke-miterlimit" "10"
        , C.attr "stroke-width" "2"
        ]
        []
    ]

viewDiamondFilled :: forall html msg. C.Html html => html msg
viewDiamondFilled =
  C.elem (C.ElemName "svg")
    [ C.attr "fill" "#000000", C.attr "width" "800", C.attr "height" "800", C.attr "viewBox" "0 0 32 32" ]
    [ C.elem (C.ElemName "path")
        [ C.attr "d"
            "M 30.531,15.47 16.53,1.47 C 16.394,1.334 16.207,1.25 16,1.25 c -0.207,0 -0.395,0.084 -0.53,0.22 l -14,14 C 1.334,15.606 1.25,15.793 1.25,16 c 0,0.207 0.084,0.395 0.22,0.53 l 14,14.001 c 0.136,0.135 0.323,0.219 0.53,0.219 0.207,0 0.394,-0.084 0.53,-0.219 L 30.531,16.53 c 0.135,-0.136 0.218,-0.323 0.218,-0.53 0,-0.207 -0.083,-0.394 -0.218,-0.53 z M 16,28.939 3.061,16 16,3.061 28.939,16 Z"
        , C.attr "id" "path77"
        ]
        []
    , C.elem (C.ElemName "path")
        [ C.attr "style" "fill:#000000;stroke-width:0.0411333"
        , C.attr "d"
            "m 9.0657409,22.622953 -6.9026582,-6.572511 6.9027536,-6.5724184 6.9027547,-6.572419 6.902658,6.5725104 6.902657,6.572511 -6.902753,6.572418 -6.902754,6.572419 z"
        , C.attr "id" "path262"
        ]
        []
    ]

viewDiamond :: forall html msg. C.Html html => html msg
viewDiamond =
  C.elem (C.ElemName "svg")
    [ C.attr "fill" "#000000"
    , C.attr "width" "800px"
    , C.attr "height" "800px"
    , C.attr "viewBox" "0 0 32 32"
    , C.attr "version" "1.1"
    , C.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ C.elem (C.ElemName "title") [] [ C.text "diamond" ]
    , C.elem (C.ElemName "path")
        [ C.attr "d"
            "M30.531 15.47l-14.001-14c-0.136-0.136-0.323-0.22-0.53-0.22s-0.395 0.084-0.53 0.22l-14 14c-0.136 0.136-0.22 0.323-0.22 0.53s0.084 0.395 0.22 0.53l14 14.001c0.136 0.135 0.323 0.219 0.53 0.219s0.394-0.084 0.53-0.219l14.001-14.001c0.135-0.136 0.218-0.323 0.218-0.53s-0.083-0.394-0.218-0.53l0 0zM16 28.939l-12.939-12.939 12.939-12.939 12.939 12.939z"
        ]
        []
    ]

viewDash :: forall html msg. C.Html html => html msg
viewDash =
  C.elem (C.ElemName "svg")
    [ C.attr "viewBox" "0 0 24 24", C.attr "fill" "none", C.attr "xmlns" "http://www.w3.org/2000/svg" ]
    [ C.elem (C.ElemName "path")
        [ C.attr "d" "M3 12L21 12"
        , C.attr "stroke" "#000000"
        , C.attr "stroke-width" "2"
        , C.attr "stroke-linecap" "round"
        , C.attr "stroke-linejoin" "round"
        ]
        []
    ]

viewChevronRight :: forall html msg. C.Html html => html msg
viewChevronRight =
  C.elem (C.ElemName "svg")
    [ C.attr "version" "1.1"
    , C.attr "xmlns" "http://www.w3.org/2000/svg"
    , C.attr "xmlns:xlink" "http://www.w3.org/1999/xlink"
    , C.attr "xmlns:sketch" "http://www.bohemiancoding.com/sketch/ns"
    , C.attr "viewBox" "-0.01 -0.01 14.02 23.99"
    ]
    [ C.elem (C.ElemName "title") [] [ C.text "chevron-right" ]
    , C.elem (C.ElemName "desc") [] [ C.text "Created with Sketch Beta." ]
    , C.elem (C.ElemName "defs") [] []
    , C.elem (C.ElemName "g")
        [ C.attr "id" "Page-1"
        , C.attr "stroke" "none"
        , C.attr "stroke-width" "1"
        , C.attr "fill" "none"
        , C.attr "fill-rule" "evenodd"
        , C.attr "sketch:type" "MSPage"
        ]
        [ C.elem (C.ElemName "g")
            [ C.attr "id" "Icon-Set"
            , C.attr "sketch:type" "MSLayerGroup"
            , C.attr "transform" "translate(-473.000000, -1195.000000)"
            , C.attr "fill" "#000000"
            ]
            [ C.elem (C.ElemName "path")
                [ C.attr "d"
                    "M486.717,1206.22 L474.71,1195.28 C474.316,1194.89 473.678,1194.89 473.283,1195.28 C472.89,1195.67 472.89,1196.31 473.283,1196.7 L484.566,1206.98 L473.283,1217.27 C472.89,1217.66 472.89,1218.29 473.283,1218.69 C473.678,1219.08 474.316,1219.08 474.71,1218.69 L486.717,1207.75 C486.927,1207.54 487.017,1207.26 487.003,1206.98 C487.017,1206.71 486.927,1206.43 486.717,1206.22"
                , C.attr "id" "chevron-right"
                , C.attr "sketch:type" "MSShapeGroup"
                ]
                []
            ]
        ]
    ]
