let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.2-20220706/packages.dhall
        sha256:7a24ebdbacb2bfa27b2fc6ce3da96f048093d64e54369965a2a7b5d9892b6031

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
        , repo = "https://github.com/andys8/purescript-react-basic-dom.git"
        , version = "5031446d1613a50474306c4c5435613cd4e04516"
        }
      }

in  upstream // overrides // additions
