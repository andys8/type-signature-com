module Questions
  ( mkQuestions
  , questionFunction
  , isAnswerCorrect
  , abcd
  , toOptions
  , Option(..)
  , Answer(..)
  , AnsweredQuestion(..)
  , Question
  ) where

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
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Random as Random
import Functions (Fun(..))

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

data AnsweredQuestion = AnsweredQuestion Question Answer

derive instance Eq AnsweredQuestion
derive instance Generic AnsweredQuestion _
instance Show AnsweredQuestion where
  show = genericShow

mkQuestions :: forall m. MonadEffect m => Int -> NonEmptySet Fun -> m (Either String (NonEmptyArray Question))
mkQuestions numQuestions _ | numQuestions <= 0 = pure $ Left "numQuestions <= 0"
mkQuestions numQuestions functions = do
  let arr = NES.toUnfoldable functions
  shuffles <- shuffle arr
  qs <- mkQuestionsRec numQuestions shuffles
  pure $ note "No questions" <<< NEA.fromArray =<< qs
  where
  mkQuestionsRec :: MonadEffect m => Int -> Array Fun -> m (Either String (Array Question))
  mkQuestionsRec 0 _ = pure $ Right []
  mkQuestionsRec n fs = do
    let { before: options, after: rest } = A.splitAt 4 fs
    x <- mkQuestion options
    case x of
      Left e -> pure $ Left e
      Right q | not (questionIsValid q) ->
        mkQuestionsRec n =<< shuffle fs
      Right q -> do
        otherQuestions <- mkQuestionsRec (n - 1) rest
        pure $ (cons q) <$> otherQuestions

  questionIsValid q = toOptions q == A.nubByEq hasNamingConflict (toOptions q)

  mkQuestion :: MonadEffect m => Array Fun -> m (Either String Question)
  mkQuestion [ optionA, optionB, optionC, optionD ] = do
    o <- liftEffect $ toEnum <$> Random.randomInt 0 3
    pure case o of
      Just correctOption -> Right $ { correctOption, optionA, optionB, optionC, optionD }
      Nothing -> Left "Could not create correctOption"
  mkQuestion _ = pure $ Left "Could not create 4 options"

shuffle :: forall m a. MonadEffect m => Array a -> m (Array a)
shuffle xs = liftEffect $ map fst <<< A.sortWith snd <$> traverse (\x -> Tuple x <$> Random.random) xs

abcd :: NonEmptyArray Option
abcd = enumFromTo bottom top

isAnswerCorrect :: AnsweredQuestion -> Boolean
isAnswerCorrect (AnsweredQuestion { correctOption } answer) = correctOption == answer

hasNamingConflict :: Fun -> Fun -> Boolean
hasNamingConflict (Fun f1) (Fun f2) = f1.name == f2.name || f1.signature == f2.signature

toOptions :: Question -> Array Fun
toOptions q = [ q.optionA, q.optionB, q.optionC, q.optionD ]

questionFunction :: Question -> Fun
questionFunction q =
  case q.correctOption of
    A -> q.optionA
    B -> q.optionB
    C -> q.optionC
    D -> q.optionD

