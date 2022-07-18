module FunctionsRaw where

import Affjax.Web (URL)
import State (AllLanguages)

foreign import elmCoreUrl :: URL
foreign import haskellBaseUrl :: URL
foreign import haskellPreludeUrl :: URL
foreign import purescriptPreludeUrl :: URL

urls :: AllLanguages URL
urls =
  { haskell: haskellPreludeUrl
  , purescript: purescriptPreludeUrl
  , elm: elmCoreUrl
  }
