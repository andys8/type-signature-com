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
  , "maybe"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "react-icons"
  , "strings"
  , "web-dom"
  , "web-html"
  ]
}
