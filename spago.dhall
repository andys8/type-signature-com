{ name = "type-signature-com"
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "exceptions"
  , "maybe"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-dom"
  , "web-html"
  ]
}
