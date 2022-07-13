module State where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Set (Set)
import Data.Show.Generic (genericShow)
import Data.Tuple.Nested (type (/\))
import Effect.Aff (Aff, Milliseconds(..), delay)
import Functions (Fun(..))

type State =
  { allFunctions :: Set Fun
  , gameState :: GameState
  }

data GameState
  = GameBeforeStart
  | GameInProgress GameInProgressState
  | GameEnd

derive instance Generic GameState _
derive instance Eq GameState
instance Show GameState where
  show = genericShow

type GameInProgressState =
  { answeredQuestions :: Array AnsweredQuestion
  , currentQuestion :: Question
  , currentAnswer :: Maybe Answer
  , nextQuestions :: Array Question
  }

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

data Action
  = ActionGameStart
  | ActionAnswer Answer
  | ActionNextQuestion

initState :: Set Fun -> State
initState allFunctions = { allFunctions, gameState: GameBeforeStart }

reducer :: State -> Action -> { state :: State, effects :: Array (Aff (Array Action)) }
reducer state ActionGameStart =
  { state: state { gameState = GameInProgress gameInProgressState }
  , effects: []
  }
  where
  gameInProgressState =
    { answeredQuestions: []
    , currentQuestion: question0
    , currentAnswer: Nothing
    , nextQuestions: [ question1 ]
    }
  question0 =
    { correctOption: A
    , optionA: Fun { name: "a0", signature: "a -> a" }
    , optionB: Fun { name: "b0", signature: "a -> a" }
    , optionC: Fun { name: "c0", signature: "a -> a" }
    , optionD: Fun { name: "d0", signature: "a -> a" }
    }
  question1 =
    { correctOption: A
    , optionA: Fun { name: "a1", signature: "a -> a" }
    , optionB: Fun { name: "b1", signature: "a -> a" }
    , optionC: Fun { name: "c1", signature: "a -> a" }
    , optionD: Fun { name: "d1", signature: "a -> a" }
    }

reducer state@{ gameState } (ActionAnswer answer) =
  { state: state { gameState = newGameState }
  , effects:
      [ do
          delay (Milliseconds 2000.0)
          pure [ ActionNextQuestion ]
      ]
  }
  where
  newGameState =
    case gameState of
      GameInProgress s -> GameInProgress $ s { currentAnswer = Just answer }
      GameBeforeStart -> gameState
      GameEnd -> gameState

reducer state ActionNextQuestion =
  { state: state { gameState = GameEnd }
  , effects: []
  }

