module State where

import Prelude

import Data.Array ((:))
import Data.Array as A
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NEA
import Data.DateTime.Instant (Instant)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..), isJust)
import Data.Set.NonEmpty (NonEmptySet)
import Data.Show.Generic (genericShow)
import Effect.Aff (Aff, Milliseconds(..), delay)
import Effect.Class (liftEffect)
import Effect.Class.Console (error)
import Effect.Now (now)
import Foreign.Confetti (confetti, schoolPride)
import Functions (Fun)
import Languages (AllLanguages, Language(..))
import Questions (Answer, AnsweredQuestion(..), Question, mkQuestions, toStat)
import React.Basic.Hooks.Aff (noEffects)

type State =
  { functions :: Functions
  , language :: Language
  , gameState :: GameState
  }

type Functions = AllLanguages (NonEmptySet Fun)

data GameState
  = GameBeforeStart
  | GameInProgress GameInProgressState
  | GameEnd GameEndState

derive instance Generic GameState _
derive instance Eq GameState
instance Show GameState where
  show = genericShow

type GameInProgressState =
  { answeredQuestions :: Array AnsweredQuestion
  , currentQuestion :: Question
  , currentAnswer :: Maybe Answer
  , nextQuestions :: Array Question
  , startTime :: Instant
  }

type GameEndState =
  { answeredQuestions :: Array AnsweredQuestion
  , startTime :: Instant
  }

data Action
  = ActionGameStart
  | ActionLanguageSet Language
  | ActionNewGame (NonEmptyArray Question) Instant
  | ActionAnswer Answer
  | ActionNextQuestion

initState :: Functions -> State
initState functions =
  { functions
  , language: Haskell
  , gameState: GameBeforeStart
  }

reducer :: State -> Action -> { state :: State, effects :: Array (Aff (Array Action)) }
reducer state ActionGameStart =
  { state, effects: [ newGame ] }
  where
  numQuestions = 6
  newGame = liftEffect do
    currentTime <- now
    questions <- (mkQuestions numQuestions $ toFunctions state)
    case questions of
      Left e -> error e *> pure []
      Right qs -> pure [ ActionNewGame qs currentTime ]

reducer state (ActionLanguageSet language) = noEffects $ state { language = language }

reducer state (ActionNewGame questions startTime) =
  noEffects $ state { gameState = GameInProgress gameInProgressState }
  where
  { head, tail } = NEA.uncons questions
  gameInProgressState =
    { answeredQuestions: []
    , currentQuestion: head
    , currentAnswer: Nothing
    , nextQuestions: tail
    , startTime
    }

reducer state (ActionAnswer _) | isGameInTransition state = noEffects state

reducer state@{ gameState } (ActionAnswer answer) =
  { state: state { gameState = newGameState }
  , effects:
      [ do
          when isAnswerCorrect $ liftEffect confetti
          delay (Milliseconds 1500.0)
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
      GameEnd _ -> gameState

reducer state ActionNextQuestion =
  { state: state { gameState = newGameState }
  , effects: [ liftEffect winAnimation ]
  }
  where
  winAnimation = case newGameState of
    GameEnd s | hasWinAnimationThreshold s -> schoolPride *> pure []
    _ -> pure []

  hasWinAnimationThreshold { answeredQuestions } = (toStat answeredQuestions).score > 0.8

  newGameState =
    case state.gameState of
      GameInProgress s -> nextQuestion s
      a -> a

  nextQuestion :: GameInProgressState -> GameState
  nextQuestion s@{ startTime } =
    case s.currentAnswer of
      Just answer ->
        let
          answeredQuestion = AnsweredQuestion s.currentQuestion answer
          answeredQuestions = answeredQuestion : s.answeredQuestions
        in
          case A.uncons s.nextQuestions of
            Nothing -> GameEnd { startTime, answeredQuestions }
            Just { head, tail } ->
              GameInProgress
                { answeredQuestions
                , currentQuestion: head
                , currentAnswer: Nothing
                , nextQuestions: tail
                , startTime
                }
      Nothing -> GameInProgress s

toFunctions :: State -> NonEmptySet Fun
toFunctions { functions, language } = case language of
  Haskell -> functions.haskell
  PureScript -> functions.purescript
  Elm -> functions.elm

isGameInTransition :: State -> Boolean
isGameInTransition { gameState } = case gameState of
  GameInProgress s -> isJust s.currentAnswer
  _ -> false
