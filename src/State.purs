module State where

import Prelude

import Effect.Aff (Aff, Milliseconds(..), delay)
import Effect.Class.Console (log)

newtype State = State String

derive newtype instance Show State
derive newtype instance Eq State

data Action = ActionSet String

initState :: State
initState = State ""

reducer :: State -> Action -> { state :: State, effects :: Array (Aff (Array Action)) }
reducer state (ActionSet x) =
  { state: State x
  , effects:
      [ do
          delay (Milliseconds 3000.0)
          log "delayed"
          pure [ ActionSet "c" ]
      ]
  }
