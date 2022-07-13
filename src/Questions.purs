module Questions where

import Prelude

import Data.Array (cons)
import Data.Array as A
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NEA
import Data.Bounded.Generic (genericBottom, genericTop)
import Data.Either (Either(..), note)
import Data.Enum (class BoundedEnum, class Enum, enumFromTo, toEnum)
import Data.Enum.Generic (genericCardinality, genericFromEnum, genericPred, genericSucc, genericToEnum)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Set.NonEmpty (NonEmptySet)
import Data.Set.NonEmpty as NES
import Data.Show.Generic (genericShow)
import Data.Traversable (traverse)
import Data.Tuple (Tuple(..), fst, snd)
import Data.Tuple.Nested (type (/\))
import Effect (Effect)
import Effect.Random as Random
import Functions (Fun)

data Option = A | B | C | D

derive instance Eq Option
derive instance Ord Option
derive instance Generic Option _

instance Bounded Option where
  bottom = genericBottom
  top = genericTop

instance BoundedEnum Option where
  cardinality = genericCardinality
  toEnum = genericToEnum
  fromEnum = genericFromEnum

instance Enum Option where
  succ = genericSucc
  pred = genericPred

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

mkQuestions :: Int -> NonEmptySet Fun -> Effect (Either String (NonEmptyArray Question))
mkQuestions numQuestions _ | numQuestions <= 0 = pure $ Left "numQuestions <= 0"
mkQuestions numQuestions functions = do
  let arr = NES.toUnfoldable functions
  shuffles <- shuffle arr
  qs <- mkQuestionsRec numQuestions shuffles
  pure $ note "No questions" <<< NEA.fromArray =<< qs
  where
  mkQuestionsRec :: Int -> Array Fun -> Effect (Either String (Array Question))
  mkQuestionsRec 0 _ = pure $ Right []
  mkQuestionsRec n fs = do
    let { before: options, after: rest } = A.splitAt 4 fs
    x <- mkQuestion options
    case x of
      Left e -> pure $ Left e
      Right q -> do
        otherQuestions <- mkQuestionsRec (n - 1) rest
        pure $ (cons q) <$> otherQuestions

  mkQuestion :: Array Fun -> Effect (Either String Question)
  mkQuestion [ optionA, optionB, optionC, optionD ] = do
    o <- toEnum <$> Random.randomInt 0 3
    pure case o :: Maybe Option of
      Just correctOption -> Right $ { correctOption, optionA, optionB, optionC, optionD }
      Nothing -> Left "Could not create correctOption"
  mkQuestion _ = pure $ Left "Could not create 4 options"

shuffle :: forall a. Array a -> Effect (Array a)
shuffle xs = map fst <<< A.sortWith snd <$> traverse (\x -> Tuple x <$> Random.random) xs

-- TODO: Remove?
shuffleNE :: forall a. NonEmptyArray a -> Effect (NonEmptyArray a)
shuffleNE xs = map fst <<< NEA.sortWith snd <$> traverse (\x -> Tuple x <$> Random.random) xs

abcd :: NonEmptyArray Option
abcd = enumFromTo bottom top
