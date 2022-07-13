module Questions where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Set.NonEmpty (NonEmptySet)
import Data.Show.Generic (genericShow)
import Data.Tuple.Nested (type (/\))
import Functions (Fun(..))

data Option = A | B | C | D

derive instance Generic Option _
derive instance Eq Option
instance Show Option where
  show = genericShow

type Question =
  { correctOption :: Option
  , optionA :: Fun
  , optionB :: Fun
  , optionC :: Fun
  , optionD :: Fun
  }

type Answer = Option

newtype AnsweredQuestion = AnsweredQuestion (Question /\ Answer)

derive newtype instance Eq AnsweredQuestion
derive newtype instance Show AnsweredQuestion

mkQuestions :: Int -> NonEmptySet Fun -> Array Question
mkQuestions n _ | n <= 0 = []
mkQuestions n functions = pure
  { correctOption: A
  , optionA: Fun { name: "a0", signature: "a -> a" }
  , optionB: Fun { name: "b0", signature: "a -> a" }
  , optionC: Fun { name: "c0", signature: "a -> a" }
  , optionD: Fun { name: "d0", signature: "a -> a" }
  }
