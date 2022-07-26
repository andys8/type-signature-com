{ name = "type-signature-com"
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "arrays"
  , "bifunctors"
  , "console"
  , "datetime"
  , "effect"
  , "either"
  , "enums"
  , "exceptions"
  , "foldable-traversable"
  , "integers"
  , "maybe"
  , "newtype"
  , "now"
  , "ordered-collections"
  , "parallel"
  , "prelude"
  , "random"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "react-icons"
  , "record"
  , "strings"
  , "tuples"
  , "unsafe-coerce"
  , "web-dom"
  , "web-html"
  ]
}
