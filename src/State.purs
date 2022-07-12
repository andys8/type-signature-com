module State where

import Prelude

import Data.Show.Generic (genericShow)
import Effect.Aff (Aff, Milliseconds(..), delay)
import Effect.Class.Console (log)
import Data.Generic.Rep (class Generic)

type State = { gameState :: GameState }

data GameState
  = GameNotYetStarted
  | GameInProgress

derive instance Generic GameState _
derive instance Eq GameState
instance Show GameState where
  show = genericShow

data Action =
  ActionGameStart

initState :: State
initState = { gameState: GameNotYetStarted }

reducer :: State -> Action -> { state :: State, effects :: Array (Aff (Array Action)) }
reducer state ActionGameStart =
  { state: state { gameState = GameInProgress }
  , effects:
      [ do
          delay (Milliseconds 3000.0)
          log "delayed"
          pure []
      ]
  }

