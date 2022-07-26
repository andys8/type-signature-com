module FunctionsRaw where

import Affjax.Web (URL)
import Languages (AllFunctions)

foreign import elmCoreUrl :: URL
foreign import purescriptFunctionsUrl :: URL
foreign import haskellFunctionsUrl :: URL
foreign import haskellLensUrl :: URL

urls :: AllFunctions URL
urls =
  { haskell: haskellFunctionsUrl
  , haskellLens: haskellLensUrl
  , purescript: purescriptFunctionsUrl
  , elm: elmCoreUrl
  }
