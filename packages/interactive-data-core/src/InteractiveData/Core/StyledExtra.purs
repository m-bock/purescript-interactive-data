module InteractiveData.Core.StyledExtra
  ( css
  , styleElemsD
  , styles
  )
  where

import Prelude

import Chameleon.Styled (Style, decl, declWith, toStyle)
import Chameleon.Styled.Elems (class StyleElems, styleElems')
import Data.Array (intercalate)
import Data.Interpolate (i)
import Data.Tuple.Nested ((/\))
import Prim.TypeError (class Warn, Text)

styleElemsD
  :: forall rowIn rowOut
   . StyleElems rowIn rowOut
  => Warn (Text "Debug style usage")
  => String
  -> Record rowIn
  -> Record rowOut
styleElemsD name = styleElems' name (debug "0, 255, 0")

debug :: String -> Int -> String -> Style
debug color _ name =
  toStyle $
    declWith "::after"
      [ i "content: \"" name "\""
      , "position: absolute"
      , "z-index: 1000"
      , "bottom: 0"
      , "right: 2px"
      , "font-size: 8px"
      , i "color: rgba(" color ", 0.5)"
      ] /\ decl
      [ i "outline: 1px solid rgba(" color ", 0.5)"
      , "outline-offset: -1px"
      , "position: relative"
      ]

styles :: Array String -> String
styles = intercalate "\n" <<< map (\s -> s <> "\n")

css :: String -> String
css = identity