module Functions (loadFunctions, parseFunctions, Fun(..)) where

import Prelude

import Data.Array as A
import Data.Either (Either(..), note)
import Data.Newtype (class Newtype)
import Data.Set.NonEmpty (NonEmptySet)
import Data.Set.NonEmpty as NES
import Affjax.ResponseFormat (string)
import Affjax.Web (URL, get, printError)
import Data.Bifunctor (bimap)
import Effect.Aff (Aff)
import Data.String (Pattern(..), split, trim, null)
import Data.Traversable (traverse)

newtype Fun = Fun { name :: String, signature :: String }

derive newtype instance Show Fun
derive newtype instance Eq Fun
derive newtype instance Ord Fun
derive instance Newtype Fun _

loadFunctions :: URL -> Aff (Either String String)
loadFunctions url = bimap printError _.body <$> get string url

parseFunctions :: String -> Either String (NonEmptySet Fun)
parseFunctions = toNonEmpty <=< traverse (mkFun <<< lineToFunction) <<< toLines
  where
  toLines = A.filter (not <<< null <<< trim) <<< split (Pattern "\n")
  lineToFunction = split (Pattern " :: ")
  mkFun [ name, signature ] = Right $ Fun { name, signature }
  mkFun x = Left $ "Couldn't parse line: " <> show x
  toNonEmpty = note "Empty" <<< NES.fromFoldable
