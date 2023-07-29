module InteractiveData.App.UI.Assets where

import VirtualDOM as VD

viewTreeMenu :: forall html msg. VD.Html html => html msg
viewTreeMenu =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "width" "800px"
    , VD.attr "height" "800px"
    , VD.attr "viewBox" "0 0 400 400"
    , VD.attr "fill" "none"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M203 64C201.497 149.148 199.374 261.958 203 335"
        , VD.attr "stroke" "#000000"
        , VD.attr "stroke-opacity" "0.9"
        , VD.attr "stroke-width" "16"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        ]
        []
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M263 267C221.502 270.141 178.013 281.069 137 275.39"
        , VD.attr "stroke" "#000000"
        , VD.attr "stroke-opacity" "0.9"
        , VD.attr "stroke-width" "16"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        ]
        []
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M248 211.191C219.278 210.419 173.975 212.182 156 213"
        , VD.attr "stroke" "#000000"
        , VD.attr "stroke-opacity" "0.9"
        , VD.attr "stroke-width" "16"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        ]
        []
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M227 151C209.488 149.283 191.824 149.403 174 149"
        , VD.attr "stroke" "#000000"
        , VD.attr "stroke-opacity" "0.9"
        , VD.attr "stroke-width" "16"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        ]
        []
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M210 102C205.442 102 200.669 102 196 102"
        , VD.attr "stroke" "#000000"
        , VD.attr "stroke-opacity" "0.9"
        , VD.attr "stroke-width" "16"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        ]
        []
    ]

viewSwitch :: forall html msg. VD.Html html => html msg
viewSwitch =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "width" "800px"
    , VD.attr "height" "800px"
    , VD.attr "viewBox" "0 0 24 24"
    , VD.attr "fill" "none"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M21 9L9 9"
        , VD.attr "stroke" "#323232"
        , VD.attr "stroke-width" "2"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        ]
        []
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M15 15L3 15"
        , VD.attr "stroke" "#323232"
        , VD.attr "stroke-width" "2"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        ]
        []
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d"
            "M18 12L20.913 9.08704V9.08704C20.961 9.03897 20.961 8.96103 20.913 8.91296V8.91296L18 6"
        , VD.attr "stroke" "#323232"
        , VD.attr "stroke-width" "2"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        ]
        []
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d"
            "M6 18L3.08704 15.087V15.087C3.03897 15.039 3.03897 14.961 3.08704 14.913V14.913L6 12"
        , VD.attr "stroke" "#323232"
        , VD.attr "stroke-width" "2"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        ]
        []
    ]

viewPageNotFound :: forall html msg. VD.Html html => html msg
viewPageNotFound =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "fill" "none"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    , VD.attr "viewBox" "38.15 62.11 73.28 86.01"
    ]
    [ VD.elem (VD.ElemName "path")
        [ VD.attr "fill-rule" "evenodd"
        , VD.attr "clip-rule" "evenodd"
        , VD.attr "d"
            "M38.155 140.475L48.988 62.1108L92.869 67.0568L111.437 91.0118L103.396 148.121L38.155 140.475ZM84.013 94.0018L88.827 71.8068L54.046 68.3068L44.192 135.457L98.335 142.084L104.877 96.8088L84.013 94.0018ZM59.771 123.595C59.394 123.099 56.05 120.299 55.421 119.433C64.32 109.522 86.05 109.645 92.085 122.757C91.08 123.128 86.59 125.072 85.71 125.567C83.192 118.25 68.445 115.942 59.771 123.595ZM76.503 96.4988L72.837 99.2588L67.322 92.6168L59.815 96.6468L56.786 91.5778L63.615 88.1508L59.089 82.6988L64.589 79.0188L68.979 85.4578L76.798 81.5328L79.154 86.2638L72.107 90.0468L76.503 96.4988Z"
        , VD.attr "fill" "#000000"
        ]
        []
    ]

viewLevelUp :: forall html msg. VD.Html html => html msg
viewLevelUp =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "width" "800px"
    , VD.attr "height" "800px"
    , VD.attr "viewBox" "0 0 16 16"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ VD.elem (VD.ElemName "path")
        [ VD.attr "fill" "#000000"
        , VD.attr "d"
            "M4.29289,4.297105 L8,0.59 L11.7071,4.297105 C12.0976,4.687635 12.0976,5.320795 11.7071,5.711315 C11.3166,6.101845 10.6834,6.101845 10.2929,5.711315 L9,4.418425 L9,11.004215 C9,11.004515 9,11.003915 9,11.004215 L9,12.004215 C9,12.556515 9.44772,13.004215 10,13.004215 L14,13.004215 C14.5523,13.004215 15,13.451915 15,14.004215 C15,14.556515 14.5523,15.004215 14,15.004215 L10,15.004215 C8.34315,15.004215 7,13.661115 7,12.004215 L7,4.418425 L5.70711,5.711315 C5.31658,6.101845 4.68342,6.101845 4.29289,5.711315 C3.90237,5.320795 3.90237,4.687635 4.29289,4.297105 Z"
        ]
        []
    ]

viewLabel2 :: forall html msg. VD.Html html => html msg
viewLabel2 =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "fill" "#000000"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    , VD.attr "viewBox" "10 14 20 12"
    ]
    [ VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M25 14l5 6-5 6H10V14h15zm-1 2H12v8h12l3.5-4-3.5-4z" ]
        []
    ]

viewLabel :: forall html msg. VD.Html html => html msg
viewLabel =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "fill" "#000000"
    , VD.attr "height" "800px"
    , VD.attr "width" "800px"
    , VD.attr "version" "1.1"
    , VD.attr "id" "Capa_1"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    , VD.attr "xmlns:xlink" "http://www.w3.org/1999/xlink"
    , VD.attr "viewBox" "0 0 486.82 486.82"
    , VD.attr "xml:space" "preserve"
    ]
    [ VD.elem (VD.ElemName "g") []
        [ VD.elem (VD.ElemName "path")
            [ VD.attr "d"
                "M486.82,21.213L465.607,0l-42.768,42.768H238.991L0,281.759L205.061,486.82l238.992-238.991V63.98L486.82,21.213z\r\n\t\t M414.053,235.403L205.061,444.394L42.427,281.759L251.418,72.768h141.421l-40.097,40.097c-14.56-6.167-32.029-3.326-43.898,8.543\r\n\t\tc-15.621,15.621-15.621,40.948,0,56.569c15.621,15.621,40.948,15.621,56.568,0c11.869-11.869,14.71-29.338,8.543-43.898\r\n\t\tl40.097-40.097V235.403z"
            ]
            []
        ]
    ]

viewKeySolid :: forall html msg. VD.Html html => html msg
viewKeySolid =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "xmlns" "http://www.w3.org/2000/svg", VD.attr "viewBox" "0 0 512 512" ]
    [ VD.elem (VD.ElemName "path")
        [ VD.attr "d"
            "M336 352c97.2 0 176-78.8 176-176S433.2 0 336 0S160 78.8 160 176c0 18.7 2.9 36.8 8.3 53.7L7 391c-4.5 4.5-7 10.6-7 17v80c0 13.3 10.7 24 24 24h80c13.3 0 24-10.7 24-24V448h40c13.3 0 24-10.7 24-24V384h40c6.4 0 12.5-2.5 17-7l33.3-33.3c16.9 5.4 35 8.3 53.7 8.3zM376 96a40 40 0 1 1 0 80 40 40 0 1 1 0-80z"
        ]
        []
    ]

viewJson :: forall html msg. VD.Html html => html msg
viewJson =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "width" "800px"
    , VD.attr "height" "800px"
    , VD.attr "viewBox" "0 0 16 16"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    , VD.attr "fill" "#000000"
    ]
    [ VD.elem (VD.ElemName "path")
        [ VD.attr "fill-rule" "evenodd"
        , VD.attr "clip-rule" "evenodd"
        , VD.attr "d"
            "M6 2.984V2h-.09c-.313 0-.616.062-.909.185a2.33 2.33 0 0 0-.775.53 2.23 2.23 0 0 0-.493.753v.001a3.542 3.542 0 0 0-.198.83v.002a6.08 6.08 0 0 0-.024.863c.012.29.018.58.018.869 0 .203-.04.393-.117.572v.001a1.504 1.504 0 0 1-.765.787 1.376 1.376 0 0 1-.558.115H2v.984h.09c.195 0 .38.04.556.121l.001.001c.178.078.329.184.455.318l.002.002c.13.13.233.285.307.465l.001.002c.078.18.117.368.117.566 0 .29-.006.58-.018.869-.012.296-.004.585.024.87v.001c.033.283.099.558.197.824v.001c.106.273.271.524.494.753.223.23.482.407.775.53.293.123.596.185.91.185H6v-.984h-.09c-.2 0-.387-.038-.563-.115a1.613 1.613 0 0 1-.457-.32 1.659 1.659 0 0 1-.309-.467c-.074-.18-.11-.37-.11-.573 0-.228.003-.453.011-.672.008-.228.008-.45 0-.665a4.639 4.639 0 0 0-.055-.64 2.682 2.682 0 0 0-.168-.609A2.284 2.284 0 0 0 3.522 8a2.284 2.284 0 0 0 .738-.955c.08-.192.135-.393.168-.602.033-.21.051-.423.055-.64.008-.22.008-.442 0-.666-.008-.224-.012-.45-.012-.678a1.47 1.47 0 0 1 .877-1.354 1.33 1.33 0 0 1 .563-.121H6zm4 10.032V14h.09c.313 0 .616-.062.909-.185.293-.123.552-.3.775-.53.223-.23.388-.48.493-.753v-.001c.1-.266.165-.543.198-.83v-.002c.028-.28.036-.567.024-.863-.012-.29-.018-.58-.018-.869 0-.203.04-.393.117-.572v-.001a1.502 1.502 0 0 1 .765-.787 1.38 1.38 0 0 1 .558-.115H14v-.984h-.09c-.196 0-.381-.04-.557-.121l-.001-.001a1.376 1.376 0 0 1-.455-.318l-.002-.002a1.415 1.415 0 0 1-.307-.465v-.002a1.405 1.405 0 0 1-.118-.566c0-.29.006-.58.018-.869a6.174 6.174 0 0 0-.024-.87v-.001a3.537 3.537 0 0 0-.197-.824v-.001a2.23 2.23 0 0 0-.494-.753 2.331 2.331 0 0 0-.775-.53 2.325 2.325 0 0 0-.91-.185H10v.984h.09c.2 0 .387.038.562.115.174.082.326.188.457.32.127.134.23.29.309.467.074.18.11.37.11.573 0 .228-.003.452-.011.672-.008.228-.008.45 0 .665.004.222.022.435.055.64.033.214.089.416.168.609a2.285 2.285 0 0 0 .738.955 2.285 2.285 0 0 0-.738.955 2.689 2.689 0 0 0-.168.602c-.033.21-.051.423-.055.64a9.15 9.15 0 0 0 0 .666c.008.224.012.45.012.678a1.471 1.471 0 0 1-.877 1.354 1.33 1.33 0 0 1-.563.121H10z"
        ]
        []
    ]

viewHome :: forall html msg. VD.Html html => html msg
viewHome =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "fill" "#000000"
    , VD.attr "width" "800px"
    , VD.attr "height" "800px"
    , VD.attr "viewBox" "0 0 32 32"
    , VD.attr "version" "1.1"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ VD.elem (VD.ElemName "title") [] [ VD.text "home" ]
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d"
            "M30.488 13.431l-14-12c-0.13-0.112-0.301-0.18-0.488-0.18s-0.358 0.068-0.489 0.181l0.001-0.001-14 12c-0.161 0.138-0.262 0.342-0.262 0.569v16c0 0.414 0.336 0.75 0.75 0.75h28c0.414-0 0.75-0.336 0.75-0.75v0-16c-0-0.227-0.101-0.431-0.261-0.569l-0.001-0.001zM11.75 29.25v-5.25c0-2.347 1.903-4.25 4.25-4.25s4.25 1.903 4.25 4.25v0 5.25zM29.25 29.25h-7.5v-5.25c0-3.176-2.574-5.75-5.75-5.75s-5.75 2.574-5.75 5.75v0 5.25h-7.5v-14.905l13.25-11.356 13.25 11.356z"
        ]
        []
    ]

viewExpandUp :: forall html msg. VD.Html html => html msg
viewExpandUp =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "viewBox" "0 0 24 24"
    , VD.attr "fill" "none"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ VD.elem (VD.ElemName "path") [ VD.attr "d" "M18 18L12 12L6 18", VD.attr "stroke" "#222222" ]
        []
    , VD.elem (VD.ElemName "path") [ VD.attr "d" "M18 12L12 6L6 12", VD.attr "stroke" "#222222" ] []
    ]

viewExpandDown :: forall html msg. VD.Html html => html msg
viewExpandDown =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "viewBox" "0 0 24 24"
    , VD.attr "fill" "none"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ VD.elem (VD.ElemName "path") [ VD.attr "d" "M18 9L12 15L6 9", VD.attr "stroke" "#222222" ] []
    ]

viewDotMenuSolid :: forall html msg. VD.Html html => html msg
viewDotMenuSolid =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "fill" "#000000"
    , VD.attr "enable-background" "new 0 0 32 32"
    , VD.attr "id" "Glyph"
    , VD.attr "version" "1.1"
    , VD.attr "xml:space" "preserve"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    , VD.attr "xmlns:xlink" "http://www.w3.org/1999/xlink"
    , VD.attr "viewBox" "3 13 26 6"
    ]
    [ VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M16,13c-1.654,0-3,1.346-3,3s1.346,3,3,3s3-1.346,3-3S17.654,13,16,13z"
        , VD.attr "id" "XMLID_287_"
        ]
        []
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M6,13c-1.654,0-3,1.346-3,3s1.346,3,3,3s3-1.346,3-3S7.654,13,6,13z"
        , VD.attr "id" "XMLID_289_"
        ]
        []
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d" "M26,13c-1.654,0-3,1.346-3,3s1.346,3,3,3s3-1.346,3-3S27.654,13,26,13z"
        , VD.attr "id" "XMLID_291_"
        ]
        []
    ]

viewDotMenu :: forall html msg. VD.Html html => html msg
viewDotMenu =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "enable-background" "new 0 0 32 32"
    , VD.attr "id" "Editable-line"
    , VD.attr "version" "1.1"
    , VD.attr "xml:space" "preserve"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    , VD.attr "xmlns:xlink" "http://www.w3.org/1999/xlink"
    , VD.attr "viewBox" "3 13 26 6"
    ]
    [ VD.elem (VD.ElemName "circle")
        [ VD.attr "cx" "16"
        , VD.attr "cy" "16"
        , VD.attr "fill" "none"
        , VD.attr "id" "XMLID_878_"
        , VD.attr "r" "2"
        , VD.attr "stroke" "#000000"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        , VD.attr "stroke-miterlimit" "10"
        , VD.attr "stroke-width" "2"
        ]
        []
    , VD.elem (VD.ElemName "circle")
        [ VD.attr "cx" "6"
        , VD.attr "cy" "16"
        , VD.attr "fill" "none"
        , VD.attr "id" "XMLID_879_"
        , VD.attr "r" "2"
        , VD.attr "stroke" "#000000"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        , VD.attr "stroke-miterlimit" "10"
        , VD.attr "stroke-width" "2"
        ]
        []
    , VD.elem (VD.ElemName "circle")
        [ VD.attr "cx" "26"
        , VD.attr "cy" "16"
        , VD.attr "fill" "none"
        , VD.attr "id" "XMLID_880_"
        , VD.attr "r" "2"
        , VD.attr "stroke" "#000000"
        , VD.attr "stroke-linecap" "round"
        , VD.attr "stroke-linejoin" "round"
        , VD.attr "stroke-miterlimit" "10"
        , VD.attr "stroke-width" "2"
        ]
        []
    ]

viewDiamondFilled :: forall html msg. VD.Html html => html msg
viewDiamondFilled =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "fill" "#000000"
    , VD.attr "width" "800"
    , VD.attr "height" "800"
    , VD.attr "viewBox" "0 0 32 32"
    ]
    [ VD.elem (VD.ElemName "path")
        [ VD.attr "d"
            "M 30.531,15.47 16.53,1.47 C 16.394,1.334 16.207,1.25 16,1.25 c -0.207,0 -0.395,0.084 -0.53,0.22 l -14,14 C 1.334,15.606 1.25,15.793 1.25,16 c 0,0.207 0.084,0.395 0.22,0.53 l 14,14.001 c 0.136,0.135 0.323,0.219 0.53,0.219 0.207,0 0.394,-0.084 0.53,-0.219 L 30.531,16.53 c 0.135,-0.136 0.218,-0.323 0.218,-0.53 0,-0.207 -0.083,-0.394 -0.218,-0.53 z M 16,28.939 3.061,16 16,3.061 28.939,16 Z"
        , VD.attr "id" "path77"
        ]
        []
    , VD.elem (VD.ElemName "path")
        [ VD.attr "style" "fill:#000000;stroke-width:0.0411333"
        , VD.attr "d"
            "m 9.0657409,22.622953 -6.9026582,-6.572511 6.9027536,-6.5724184 6.9027547,-6.572419 6.902658,6.5725104 6.902657,6.572511 -6.902753,6.572418 -6.902754,6.572419 z"
        , VD.attr "id" "path262"
        ]
        []
    ]

viewDiamond :: forall html msg. VD.Html html => html msg
viewDiamond =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "fill" "#000000"
    , VD.attr "width" "800px"
    , VD.attr "height" "800px"
    , VD.attr "viewBox" "0 0 32 32"
    , VD.attr "version" "1.1"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    ]
    [ VD.elem (VD.ElemName "title") [] [ VD.text "diamond" ]
    , VD.elem (VD.ElemName "path")
        [ VD.attr "d"
            "M30.531 15.47l-14.001-14c-0.136-0.136-0.323-0.22-0.53-0.22s-0.395 0.084-0.53 0.22l-14 14c-0.136 0.136-0.22 0.323-0.22 0.53s0.084 0.395 0.22 0.53l14 14.001c0.136 0.135 0.323 0.219 0.53 0.219s0.394-0.084 0.53-0.219l14.001-14.001c0.135-0.136 0.218-0.323 0.218-0.53s-0.083-0.394-0.218-0.53l0 0zM16 28.939l-12.939-12.939 12.939-12.939 12.939 12.939z"
        ]
        []
    ]

viewChevronRight :: forall html msg. VD.Html html => html msg
viewChevronRight =
  VD.elem (VD.ElemName "svg")
    [ VD.attr "version" "1.1"
    , VD.attr "xmlns" "http://www.w3.org/2000/svg"
    , VD.attr "xmlns:xlink" "http://www.w3.org/1999/xlink"
    , VD.attr "xmlns:sketch" "http://www.bohemiancoding.com/sketch/ns"
    , VD.attr "viewBox" "-0.01 -0.01 14.02 23.99"
    ]
    [ VD.elem (VD.ElemName "title") [] [ VD.text "chevron-right" ]
    , VD.elem (VD.ElemName "desc") [] [ VD.text "Created with Sketch Beta." ]
    , VD.elem (VD.ElemName "defs") [] []
    , VD.elem (VD.ElemName "g")
        [ VD.attr "id" "Page-1"
        , VD.attr "stroke" "none"
        , VD.attr "stroke-width" "1"
        , VD.attr "fill" "none"
        , VD.attr "fill-rule" "evenodd"
        , VD.attr "sketch:type" "MSPage"
        ]
        [ VD.elem (VD.ElemName "g")
            [ VD.attr "id" "Icon-Set"
            , VD.attr "sketch:type" "MSLayerGroup"
            , VD.attr "transform" "translate(-473.000000, -1195.000000)"
            , VD.attr "fill" "#000000"
            ]
            [ VD.elem (VD.ElemName "path")
                [ VD.attr "d"
                    "M486.717,1206.22 L474.71,1195.28 C474.316,1194.89 473.678,1194.89 473.283,1195.28 C472.89,1195.67 472.89,1196.31 473.283,1196.7 L484.566,1206.98 L473.283,1217.27 C472.89,1217.66 472.89,1218.29 473.283,1218.69 C473.678,1219.08 474.316,1219.08 474.71,1218.69 L486.717,1207.75 C486.927,1207.54 487.017,1207.26 487.003,1206.98 C487.017,1206.71 486.927,1206.43 486.717,1206.22"
                , VD.attr "id" "chevron-right"
                , VD.attr "sketch:type" "MSShapeGroup"
                ]
                []
            ]
        ]
    ]
