let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.4-20220723/packages.dhall
        sha256:efb50561d50d0bebe01f8e5ab21cda51662cca0f5548392bafc3216953a0ed88

let additions = {=}

let overrides =
      { react-icons =
        { dependencies = [ "react-basic", "react-basic-dom", "unsafe-coerce" ]
        , repo = "https://github.com/andys8/purescript-react-icons.git"
        , version = "v1.0.7"
        }
      }

in  upstream // overrides // additions
