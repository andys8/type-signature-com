module FunctionsRaw where

import Affjax.Web (URL)
import Languages (AllLanguages)

foreign import elmCoreUrl :: URL
foreign import haskellFunctionsUrl :: URL
foreign import purescriptFunctionsUrl :: URL

urls :: AllLanguages URL
urls =
  { haskell: haskellFunctionsUrl
  , purescript: purescriptFunctionsUrl
  , elm: elmCoreUrl
  }
