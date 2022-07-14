module State where

import Prelude

import Data.Array ((:))
import Data.Array as A
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NEA
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Set.NonEmpty (NonEmptySet)
import Data.Show.Generic (genericShow)
import Effect.Aff (Aff, Milliseconds(..), delay)
import Effect.Class (liftEffect)
import Effect.Class.Console (error)
import Foreign.Confetti (confetti)
import Functions (Fun)
import Questions (Answer, AnsweredQuestion(..), Question, mkQuestions)

type State =
  { functions :: NonEmptySet Fun
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

data Action
  = ActionGameStart
  | ActionNewGame (NonEmptyArray Question)
  | ActionAnswer Answer
  | ActionNextQuestion

initState :: NonEmptySet Fun -> State
initState functions =
  { functions
  , gameState: GameBeforeStart
  }

reducer :: State -> Action -> { state :: State, effects :: Array (Aff (Array Action)) }
reducer state ActionGameStart =
  { state, effects: [ newGame ] }
  where
  newGame =
    liftEffect $ mkQuestions 6 state.functions
      >>= case _ of
        Left e -> error e *> pure []
        Right qs -> pure [ ActionNewGame qs ]

reducer state (ActionNewGame questions) =
  { state: state { gameState = GameInProgress gameInProgressState }
  , effects: []
  }
  where
  { head, tail } = NEA.uncons questions
  gameInProgressState =
    { answeredQuestions: []
    , currentQuestion: head
    , currentAnswer: Nothing
    , nextQuestions: tail
    }

reducer state@{ gameState } (ActionAnswer answer) =
  { state: state { gameState = newGameState }
  , effects:
      [ do
          when isAnswerCorrect $ liftEffect confetti
          delay (Milliseconds 2000.0)
          pure [ ActionNextQuestion ]
      ]
  }
  where
  isAnswerCorrect =
    case gameState of
      GameInProgress s -> s.currentQuestion.correctOption == answer
      _ -> false

  newGameState =
    case gameState of
      GameInProgress s -> GameInProgress $ s { currentAnswer = Just answer }
      GameBeforeStart -> gameState
      GameEnd -> gameState

reducer state ActionNextQuestion =
  { state: state { gameState = newGameState }
  , effects: []
  }
  where
  newGameState =
    case state.gameState of
      GameInProgress s -> nextQuestion s
      a -> a

  nextQuestion :: GameInProgressState -> GameState
  nextQuestion s =
    case A.uncons s.nextQuestions, s.currentAnswer of
      Just { head, tail }, Just answer ->
        GameInProgress
          { answeredQuestions: answeredQuestion : s.answeredQuestions
          , currentQuestion: head
          , currentAnswer: Nothing
          , nextQuestions: tail
          }
        where
        answeredQuestion = AnsweredQuestion s.currentQuestion answer
      _, _ -> GameEnd

