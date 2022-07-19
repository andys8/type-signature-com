module Components.AppGameSteps where

import Prelude

import Data.Array as A
import Data.Maybe (Maybe(..))
import Questions (isAnswerCorrect)
import React.Basic (JSX)
import React.Basic.DOM as R
import React.Icons (icon)
import React.Icons.Im (imCheckmark, imCross, imRadioChecked, imRadioUnchecked)
import State (GameInProgressState)

type Props =
  { inProgressState :: GameInProgressState
  }

appGameSteps :: Props -> JSX
appGameSteps { inProgressState } =
  R.ul
    { className: "steps font-medium text-sm pt-4 sm:pt-0"
    , key: "game-steps"
    , children: answered <> pure current <> next
    }
  where
  answered = (\x -> mkStep if isAnswerCorrect x then StepSuccess else StepError)
    <$> A.reverse inProgressState.answeredQuestions

  current = mkStep $
    if inProgressState.currentAnswer == Just inProgressState.currentQuestion.correctOption then StepSuccess
    else StepCurrent

  next = (const $ mkStep StepNext) <$> inProgressState.nextQuestions

data Step = StepSuccess | StepError | StepCurrent | StepNext

mkStep :: Step -> JSX
mkStep step = R.li { className, children: mkContent step }
  where
  className = case step of
    StepNext -> "step gap-2"
    _ -> "step gap-2 step-neutral"

mkContent :: Step -> Array JSX
mkContent StepNext = [ icon imRadioUnchecked { className: "text-neutral" } ]
mkContent StepCurrent = [ icon imRadioChecked { color: "white", className: "text-neutral animate-pulse" } ]
mkContent StepSuccess = [ icon imCheckmark { className: "text-success" } ]
mkContent StepError = [ icon imCross { className: "text-error" } ]
