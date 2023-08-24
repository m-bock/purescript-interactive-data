module Demo.Samples.CST.DataUI
  ( dataUi
  ) where

import Prelude

import Data.Maybe (Maybe)
import InteractiveData (class IDHtml, DataUI, DataUI', IDSurface, WrapMsg, WrapState, (~))
import InteractiveData as ID
import PureScript.CST.Types as CST
import Unsafe.Coerce (unsafeCoerce)

dataUi :: String
dataUi = ""

tMaybe_
  :: forall html a
   . IDHtml html
  => DataUI (IDSurface html) WrapMsg WrapState _ _ a
  -> DataUI (IDSurface html) WrapMsg WrapState _ _ (Maybe a)
tMaybe_ du = ID.maybe_
  { "Just": du
  , "Nothing": unit
  }

type DataUI_ html msg sta typ = DataUI (IDSurface html) WrapMsg WrapState msg sta typ

---

moduleName :: forall html. IDHtml html => DataUI_ html _ _ CST.ModuleName
moduleName = ID.newtype_ ID.string_

sourcePos :: forall html. IDHtml html => DataUI_ html _ _ CST.SourcePos
sourcePos = ID.record_
  { line: ID.int_
  , column: ID.int_
  }

sourceRange :: forall html. IDHtml html => DataUI_ html _ _ CST.SourceRange
sourceRange = ID.record_
  { start: sourcePos
  , end: sourcePos
  }

comment :: forall html l. IDHtml html => DataUI_ html _ _ l -> DataUI_ html _ _ (CST.Comment l)
comment du = ID.generic @_ @_ @_ @_ @"Comment" { typeName: "LineFeed" } {}
  { "Comment": ID.string_
  , "Space": ID.int_
  , "Line": du ~ ID.int_
  }

lineFeed :: forall html. IDHtml html => DataUI_ html _ _ CST.LineFeed
lineFeed = ID.generic @_ @_ @_ @_ @"LF" { typeName: "LineFeed" } {}
  { "CRLF": unit
  , "LF": unit
  }

sourceStyle :: forall html. IDHtml html => DataUI_ html _ _ CST.SourceStyle
sourceStyle = ID.generic @_ @_ @_ @_ @"ASCII" { typeName: "SourceStyle" } {}
  { "ASCII": unit
  , "Unicode": unit
  }

intValue :: forall html. IDHtml html => DataUI_ html _ _ CST.IntValue
intValue = ID.generic @_ @_ @_ @_ @"SmallInt" { typeName: "IntValue" } {}
  { "SmallInt": ID.int_
  , "BigInt": ID.string_
  , "BigHex": ID.string_
  }

token :: forall html. IDHtml html => DataUI_ html _ _ CST.Token
token = ID.generic @_ @_ @_ @_ @"TokLeftParen" { typeName: "Token" } {}
  { "TokLeftParen": unit
  , "TokRightParen": unit
  , "TokLeftBrace": unit
  , "TokRightBrace": unit
  , "TokLeftSquare": unit
  , "TokRightSquare": unit
  , "TokLeftArrow": sourceStyle
  , "TokRightArrow": sourceStyle
  , "TokRightFatArrow": sourceStyle
  , "TokDoubleColon": sourceStyle
  , "TokForall": sourceStyle
  , "TokEquals": unit
  , "TokPipe": unit
  , "TokTick": unit
  , "TokDot": unit
  , "TokComma": unit
  , "TokUnderscore": unit
  , "TokBackslash": unit
  , "TokAt": unit
  , "TokLowerName":
      ID.maybe_
        { "Just": moduleName
        , "Nothing": unit
        } ~ ID.string_
  , "TokUpperName":
      ID.maybe_
        { "Just": moduleName
        , "Nothing": unit
        } ~ ID.string_
  , "TokOperator":
      ID.maybe_
        { "Just": moduleName
        , "Nothing": unit
        } ~ ID.string_
  , "TokSymbolName":
      ID.maybe_
        { "Just": moduleName
        , "Nothing": unit
        } ~ ID.string_
  , "TokSymbolArrow": sourceStyle
  , "TokHole": ID.string_
  , "TokChar": ID.string_ ~ (unsafeCoerce 1 :: DataUI' _ _ Char)
  , "TokString": ID.string_ ~ ID.string_
  , "TokRawString": ID.string_
  , "TokInt": ID.string_ ~ intValue
  , "TokNumber": ID.string_ ~ ID.number_
  , "TokLayoutStart": ID.int_
  , "TokLayoutSep": ID.int_
  , "TokLayoutEnd": ID.int_
  }

sourceToken :: forall html. IDHtml html => DataUI_ html _ _ CST.SourceToken
sourceToken = ID.record_
  { range: sourceRange
  , leadingComments: ID.array_ (comment lineFeed)
  , trailingComments: ID.array_ (comment (unsafeCoerce 1 :: DataUI' _ _ Void))
  , value: token
  }

ident :: forall html. IDHtml html => DataUI_ html _ _ CST.Ident
ident = ID.newtype_ ID.string_

proper :: forall html. IDHtml html => DataUI_ html _ _ CST.Proper
proper = ID.newtype_ ID.string_

label :: forall html. IDHtml html => DataUI_ html _ _ CST.Label
label = ID.newtype_ ID.string_

operator :: forall html. IDHtml html => DataUI_ html _ _ CST.Operator
operator = ID.newtype_ ID.string_

name :: forall html a. IDHtml html => DataUI_ html _ _ a -> DataUI_ html _ _ (CST.Name a)
name du = ID.newtype_ $ ID.record_
  { token: sourceToken
  , name: du
  }

qualifiedName :: forall html a. IDHtml html => DataUI_ html _ _ a -> DataUI_ html _ _ (CST.QualifiedName a)
qualifiedName du = ID.newtype_ $ ID.record_
  { token: sourceToken
  , module: tMaybe_ moduleName
  , name: du
  }

wrapped :: forall html a. IDHtml html => DataUI_ html _ _ a -> DataUI_ html _ _ (CST.Wrapped a)
wrapped du = ID.newtype_ $ ID.record_
  { open: sourceToken
  , value: du
  , close: sourceToken
  }

separated :: forall html a. IDHtml html => DataUI_ html _ _ a -> DataUI_ html _ _ (CST.Separated a)
separated du = ID.newtype_ $ ID.record_
  { head: du
  , tail: ID.array_ (ID.tuple_ { "Tuple": sourceToken ~ du })
  }

labeled
  :: forall html a b. IDHtml html => DataUI_ html _ _ a -> DataUI_ html _ _ b -> DataUI_ html _ _ (CST.Labeled a b)
labeled du db = ID.newtype_ $ ID.record_
  { label: du
  , separator: sourceToken
  , value: db
  }

prefixed :: forall html a. IDHtml html => DataUI_ html _ _ a -> DataUI_ html _ _ (CST.Prefixed a)
prefixed du = ID.newtype_ $ ID.record_
  { prefix: tMaybe_ sourceToken
  , value: du
  }

delimited :: forall html a. IDHtml html => DataUI_ html _ _ a -> DataUI_ html _ _ (CST.Delimited a)
delimited du = wrapped (tMaybe_ (separated du))

delimitedNonEmpty :: forall html a. IDHtml html => DataUI_ html _ _ a -> DataUI_ html _ _ (CST.DelimitedNonEmpty a)
delimitedNonEmpty du = wrapped (separated du)

oneOrDelimited :: forall html a. IDHtml html => DataUI_ html _ _ a -> DataUI_ html _ _ (CST.OneOrDelimited a)
oneOrDelimited du = ID.generic @_ @_ @_ @_ @"One" { typeName: "OneOrDelimited" } {}
  { "One": du
  , "Many": delimitedNonEmpty du
  }
