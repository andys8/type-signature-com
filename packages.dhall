let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.4-20220718/packages.dhall
        sha256:a6d66723b6109f1e3eaf6575910f1c51aa545965ce313024ba329360e2f009ac

let additions =
      { react-icons =
        { dependencies = [ "react-basic", "react-basic-dom", "unsafe-coerce" ]
        , repo = "https://github.com/andys8/purescript-react-icons.git"
        , version = "v1.0.7"
        }
      }

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
        , repo = "https://github.com/lumihq/purescript-react-basic-dom.git"
        , version = "4633ad95b47a5806ca559dfb3b16b5339564f0ad"
        }
      }

in  upstream // overrides // additions
