module Data.Functions where

import Prelude

import Affjax.ResponseFormat (string)
import Affjax.Web (URL, get, printError)
import Data.Bifunctor (bimap)
import Data.Either (Either)
import Data.String (Pattern(..), split)
import Effect.Aff (Aff)

newtype Fun = Fun String

derive newtype instance Show Fun
derive newtype instance Eq Fun

foreign import haskellBaseUrl :: URL
foreign import haskellPreludeUrl :: URL

loadFunctions :: Aff (Either String (Array Fun))
loadFunctions = do
  response <- get string haskellPreludeUrl
  pure $ bimap printError (parseFunctions <<< _.body) response
  where
  parseFunctions = map Fun <<< split (Pattern "\n")
