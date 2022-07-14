module Functions (parseFunctions, Fun(..)) where

import Prelude

import Data.Array as A
import Data.Either (Either(..), note)
import Data.Set.NonEmpty (NonEmptySet)
import Data.Set.NonEmpty as NES
import Data.String (Pattern(..), split, trim, null)
import Data.Newtype (class Newtype)
import Data.Traversable (traverse)

newtype Fun = Fun { name :: String, signature :: String }

derive newtype instance Show Fun
derive newtype instance Eq Fun
derive newtype instance Ord Fun
derive instance Newtype Fun _

parseFunctions :: String -> Either String (NonEmptySet Fun)
parseFunctions = toNonEmpty <=< traverse (mkFun <<< lineToFunction) <<< toLines
  where
  toLines = A.filter (not <<< null <<< trim) <<< split (Pattern "\n")
  lineToFunction = split (Pattern " :: ")
  mkFun [ name, signature ] = Right $ Fun { name, signature }
  mkFun x = Left $ "Couldn't parse line: " <> show x
  toNonEmpty = note "Empty" <<< NES.fromFoldable

