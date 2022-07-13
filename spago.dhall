{ name = "type-signature-com"
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "arrays"
  , "bifunctors"
  , "effect"
  , "either"
  , "enums"
  , "exceptions"
  , "foldable-traversable"
  , "maybe"
  , "ordered-collections"
  , "prelude"
  , "random"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "react-icons"
  , "strings"
  , "tuples"
  , "web-dom"
  , "web-html"
  ]
}
