module State where

import Prelude

import Data.Functions (Fun)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Effect.Aff (Aff, Milliseconds(..), delay)

type State =
  { allFunctions :: Array Fun
  , gameState :: GameState
  }

data GameState
  = GameBeforeStart
  | GameInProgress GameInProgressState
  | GameEnd

type GameInProgressState = { questionIndex :: Int }

derive instance Generic GameState _
derive instance Eq GameState
instance Show GameState where
  show = genericShow

data Action
  = ActionGameStart
  | ActionAnswer
  | ActionNextQuestion

initState :: Array Fun -> State
initState allFunctions = { allFunctions, gameState: GameBeforeStart }

reducer :: State -> Action -> { state :: State, effects :: Array (Aff (Array Action)) }
reducer state ActionGameStart =
  { state: state { gameState = GameInProgress { questionIndex: 0 } }
  , effects: []
  }

reducer state ActionAnswer =
  { state: state
  , effects:
      [ do
          delay (Milliseconds 3000.0)
          pure [ ActionNextQuestion ]
      ]
  }

reducer state ActionNextQuestion =
  { state: state { gameState = GameInProgress { questionIndex: 1 } }
  , effects: []
  }

