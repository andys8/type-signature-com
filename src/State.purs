module State where

import Prelude

import Data.Array ((:))
import Data.Array as A
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NEA
import Data.Bounded.Generic (genericBottom, genericTop)
import Data.Either (Either(..))
import Data.Enum (class BoundedEnum, class Enum, enumFromTo)
import Data.Enum.Generic (genericCardinality, genericFromEnum, genericPred, genericSucc, genericToEnum)
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
import React.Basic.Hooks.Aff (noEffects)

type State =
  { functions :: Functions
  , language :: Language
  , gameState :: GameState
  }

type AllLanguages a =
  { haskell :: a
  , purescript :: a
  , elm :: a
  }

type Functions = AllLanguages (NonEmptySet Fun)

data Language = Haskell | PureScript | Elm

derive instance Generic Language _
derive instance Eq Language
instance Show Language where
  show = genericShow

derive instance Ord Language

instance Bounded Language where
  bottom = genericBottom
  top = genericTop

instance BoundedEnum Language where
  cardinality = genericCardinality
  toEnum = genericToEnum
  fromEnum = genericFromEnum

instance Enum Language where
  succ = genericSucc
  pred = genericPred

data GameState
  = GameBeforeStart
  | GameInProgress GameInProgressState
  | GameEnd (Array AnsweredQuestion)

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
  | ActionLanguageSet Language
  | ActionNewGame (NonEmptyArray Question)
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
  newGame =
    liftEffect (mkQuestions 3 $ toFunctions state)
      >>= case _ of
        Left e -> error e *> pure []
        Right qs -> pure [ ActionNewGame qs ]

reducer state (ActionLanguageSet language) = noEffects $ state { language = language }

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
  , effects: []
  }
  where
  newGameState =
    case state.gameState of
      GameInProgress s -> nextQuestion s
      a -> a

  nextQuestion :: GameInProgressState -> GameState
  nextQuestion s =
    case s.currentAnswer of
      Just answer ->
        let
          answeredQuestion = AnsweredQuestion s.currentQuestion answer
          answeredQuestions = answeredQuestion : s.answeredQuestions
        in
          case A.uncons s.nextQuestions of
            Nothing -> GameEnd answeredQuestions
            Just { head, tail } ->
              GameInProgress
                { answeredQuestions
                , currentQuestion: head
                , currentAnswer: Nothing
                , nextQuestions: tail
                }
      Nothing -> GameEnd s.answeredQuestions

toFunctions :: State -> NonEmptySet Fun
toFunctions state = case state.language of
  Haskell -> state.functions.haskell
  PureScript -> state.functions.purescript
  Elm -> state.functions.elm

languages :: NonEmptyArray Language
languages = enumFromTo bottom top
