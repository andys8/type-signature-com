module Components.PageGameInProgress (pageGameInProgress) where

import Prelude

import Data.Functions (Fun(..))
import Data.Maybe (Maybe(..), isJust)
import Effect (Effect)
import Foreign.Confetti (confetti)
import Foreign.Daisyui (badge, button)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import State (Option(..), Answer, GameInProgressState)

type Props =
  { inProgressState :: GameInProgressState
  , onAnswerClick :: Answer -> Effect Unit
  }

pageGameInProgress :: Props -> JSX
pageGameInProgress { onAnswerClick, inProgressState } =
  fragment
    [ R.text $ show $ inProgressState.currentQuestion.correctOption
    , R.div_
        [ mkOptionButton A inProgressState.currentQuestion.optionA
        , mkOptionButton B inProgressState.currentQuestion.optionB
        ]
    , R.div_
        [ mkOptionButton C inProgressState.currentQuestion.optionC
        , mkOptionButton D inProgressState.currentQuestion.optionD
        ]
    ]
  where
  { currentQuestion, currentAnswer } = inProgressState
  mkOptionButton option fun =
    element button
      { color: case currentAnswer of
          Just answer | answer == option ->
            if currentQuestion.correctOption == option then "success" else "error"
          _ -> "default"
      , onClick: handler_ $
          if isJust currentAnswer then pure unit
          else do
            onAnswerClick option
            confetti {}
      , disabled: false
      , className: "gap-4 m-2"
      , children:
          [ element badge
              { size: "lg"
              , responsive: false
              , color: "primary"
              , children: [ R.text $ renderOption option ]
              }
          , R.text $ renderFun fun
          ]
      }
  renderOption = show
  renderFun (Fun x) = x
