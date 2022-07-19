module FunctionsRaw where

import Affjax.Web (URL)
import Languages (AllLanguages)

foreign import elmCoreUrl :: URL
foreign import haskellPreludeUrl :: URL
foreign import purescriptFunctionsUrl :: URL

urls :: AllLanguages URL
urls =
  { haskell: haskellPreludeUrl
  , purescript: purescriptFunctionsUrl
  , elm: elmCoreUrl
  }
