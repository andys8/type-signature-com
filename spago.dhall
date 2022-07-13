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
  , "exceptions"
  , "foldable-traversable"
  , "maybe"
  , "ordered-collections"
  , "prelude"
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
