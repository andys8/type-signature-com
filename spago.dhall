{ name = "type-signature-com"
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "bifunctors"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "foreign-object"
  , "maybe"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "strings"
  , "web-dom"
  , "web-html"
  ]
}
