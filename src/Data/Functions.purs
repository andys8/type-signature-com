module Data.Functions where

import Prelude

import Affjax.ResponseFormat (string)
import Affjax.Web (URL, get)
import Data.Either (either)
import Data.String (Pattern(..), split)
import Effect.Aff (Aff)

newtype Fun = Fun String

derive newtype instance Show Fun
derive newtype instance Eq Fun

foreign import haskellBaseUrl :: URL
foreign import haskellPreludeUrl :: URL

loadFunctions :: Aff (Array Fun)
loadFunctions = do
  response <- get string haskellPreludeUrl
  pure $ either (pure []) (parseFunctions <<< _.body) response
  where
  parseFunctions = map Fun <<< split (Pattern "\n")
