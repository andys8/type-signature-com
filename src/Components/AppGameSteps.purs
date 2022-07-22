module Components.AppGameSteps where

import Prelude

import Data.Array as A
import Data.Maybe (Maybe(..))
import Data.Monoid (guard)
import Data.String (joinWith)
import Questions (isAnswerCorrect)
import React.Basic (JSX)
import React.Basic.DOM as R
import React.Icons (icon)
import React.Icons.Im (imCheckmark, imCross, imRadioChecked, imRadioUnchecked)
import State (GameInProgressState)

type Props =
  { inProgressState :: GameInProgressState
  }

data Step = StepSuccess | StepError | StepCurrent | StepNext

derive instance Eq Step

appGameSteps :: Props -> JSX
appGameSteps { inProgressState } =
  R.ul
    { className: joinWith " "
        [ "steps max-w-full overflow-hidden font-medium text-sm pt-4 sm:pt-0"
        , if A.length answered > 2 then "justify-end" else "justify-start"
        ]
    , key: "game-steps"
    , children: answered <> pure current <> next
    }
  where
  { answeredQuestions, currentQuestion, nextQuestions, currentAnswer } = inProgressState

  answered = answeredStep <$> A.reverse answeredQuestions
  answeredStep x = mkStep if isAnswerCorrect x then StepSuccess else StepError

  current | currentAnswer == Just currentQuestion.correctOption = mkStep StepSuccess
  current = mkStep StepCurrent

  next = (const $ mkStep StepNext) <$> nextQuestions

mkStep :: Step -> JSX
mkStep step = R.li { className, children: [ mkContent step ] }
  where
  className = "step gap-2" <> guard (step /= StepNext) " step-neutral"

mkContent :: Step -> JSX
mkContent StepNext = icon imRadioUnchecked { className: "text-neutral" }
mkContent StepCurrent = icon imRadioChecked { color: "white", className: "text-neutral" }
mkContent StepSuccess = icon imCheckmark { className: "text-success" }
mkContent StepError = icon imCross { className: "text-error" }
