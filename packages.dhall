let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.2-20220624/packages.dhall
        sha256:08989ed9f53e381f879f1b7012ad7684b1ed64d7164c4ad75e306d3210a46c92

let additions = {=}

let overrides =
      { react-basic-dom =
        { dependencies =
          [ "effect"
          , "foldable-traversable"
          , "foreign-object"
          , "maybe"
          , "nullable"
          , "prelude"
          , "react-basic"
          , "unsafe-coerce"
          , "web-dom"
          , "web-events"
          , "web-file"
          , "web-html"
          ]
        , repo = "https://github.com/andys8/purescript-react-basic-dom.git"
        , version = "5031446d1613a50474306c4c5435613cd4e04516"
        }
      }

in  upstream // overrides // additions
