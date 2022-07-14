module Components.PageGameInProgress (pageGameInProgress) where

import Prelude

import Components.AppGameSteps (appGameSteps)
import Data.Maybe (Maybe(..), isJust)
import Data.Newtype (un)
import Effect (Effect)
import Foreign.Daisyui (badge, button)
import Functions (Fun(..))
import Questions (Option(..), Answer)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM (code, h1)
import React.Basic.DOM as R
import React.Basic.DOM.Events (stopPropagation)
import React.Basic.Events (handler)
import State (GameInProgressState)

type Props =
  { inProgressState :: GameInProgressState
  , onAnswerClick :: Answer -> Effect Unit
  }

pageGameInProgress :: Props -> JSX
pageGameInProgress { onAnswerClick, inProgressState } =
  fragment
    [ appGameSteps { inProgressState }
    , inCard
        [ renderQuestion inProgressState.currentQuestion
        , R.div
            { className: ""
            , children:
                [ mkOptionButton A inProgressState.currentQuestion.optionA
                , mkOptionButton B inProgressState.currentQuestion.optionB
                ]
            }
        , R.div
            { className: ""
            , children:
                [ mkOptionButton C inProgressState.currentQuestion.optionC
                , mkOptionButton D inProgressState.currentQuestion.optionD
                ]
            }
        ]
    ]
  where
  { currentQuestion, currentAnswer } = inProgressState
  mkOptionButton option fun =
    element button
      { color: case currentAnswer of
          Just answer | answer == option && option /= currentQuestion.correctOption -> "error"
          Just _ | option == currentQuestion.correctOption -> "success"
          _ -> "default"
      , onClick: handler stopPropagation $ const $
          if isJust currentAnswer then pure unit
          else onAnswerClick option
      , disabled: false
      , className: "gap-4 m-2 w-64 justify-start flex-nowrap"
      , children:
          [ element badge
              { size: "lg"
              , responsive: false
              , color: "secondary"
              , children: [ renderOption option ]
              }
          , renderFunName fun
          ]
      }
  renderOption = R.text <<< show
  renderFunName (Fun { name }) =
    -- TODO: Title on hover
    code
      { className: "font-medium font-mono text-lg normal-case truncate"
      , children: [ R.text name ]
      }

  toSignature = un Fun >>> _.signature

  -- TODO: Format function (maybe different colors)
  -- TODO: Make sure long function breaks accordingly or is prettified with line breaks
  renderQuestion q = h1
    { className: "font-mono font-medium text-2xl w-full h-24 mt-10 mb-6"
    , children: [ R.text $ toSignature $ toQuestion q ]
    }

  toQuestion q =
    case q.correctOption of
      A -> q.optionA
      B -> q.optionB
      C -> q.optionC
      D -> q.optionD

  inCard children =
    -- TODO: Card could be react component
    R.div
      { className: "card bg-base-100 shadow-xl bg-base-200 max-w-2xl mx-4"
      , children:
          [ R.div { className: "card-body items-center text-center gap-0", children } ]
      }

