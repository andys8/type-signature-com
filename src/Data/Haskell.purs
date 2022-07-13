module Data.Haskell where

import Prelude

import Affjax.ResponseFormat (string)
import Affjax.Web (URL, get, printError)
import Data.Bifunctor (bimap)
import Data.Either (Either)
import Effect.Aff (Aff)

foreign import haskellBaseUrl :: URL
foreign import haskellPreludeUrl :: URL

loadFunctions :: URL -> Aff (Either String String)
loadFunctions url = bimap printError _.body <$> get string url
