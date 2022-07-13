module Functions where

import Prelude

import Data.Either (Either(..))
import Data.Set (Set)
import Data.Set as S
import Data.String (Pattern(..), split)
import Data.Traversable (traverse)

newtype Fun = Fun { name :: String, signature :: String }

derive newtype instance Show Fun
derive newtype instance Eq Fun
derive newtype instance Ord Fun

parseFunctions :: String -> Either String (Set Fun)
parseFunctions = map S.fromFoldable <<< traverse (mkFun <<< lineToFunction) <<< toLines
  where
  toLines = split (Pattern "\n")
  lineToFunction = split (Pattern " :: ")
  mkFun [ name, signature ] = Right $ Fun { name, signature }
  mkFun x = Left $ "Couldn't parse line: " <> show x

