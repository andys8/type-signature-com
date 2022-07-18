module Components.PageGameInProgress (pageGameInProgress) where

import Prelude

import Components.AppGameSteps (appGameSteps)
import Data.Maybe (Maybe(..), isJust)
import Data.Newtype (un)
import Effect (Effect)
import Foreign.Daisyui (badge, button_)
import Functions (Fun(..))
import Languages (Language, languageIcon)
import Questions (Answer, Option(..), questionFunction)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM (code, h1)
import React.Basic.DOM as R
import React.Basic.DOM.Events (stopPropagation)
import React.Basic.Events (handler)
import React.Icons (icon)
import State (GameInProgressState)

type Props =
  { language :: Language
  , inProgressState :: GameInProgressState
  , onAnswerClick :: Answer -> Effect Unit
  }

pageGameInProgress :: Props -> JSX
pageGameInProgress { language, onAnswerClick, inProgressState } =
  fragment
    [ appGameSteps { inProgressState }
    , renderCard
        [ R.h2 { className: "card-title text-secondary", children: [ R.text "What is the type?" ] }
        , renderQuestion inProgressState.currentQuestion
        , R.div_
            [ renderAnswerButton A inProgressState.currentQuestion.optionA
            , renderAnswerButton B inProgressState.currentQuestion.optionB
            ]
        , R.div_
            [ renderAnswerButton C inProgressState.currentQuestion.optionC
            , renderAnswerButton D inProgressState.currentQuestion.optionD
            ]
        ]
    ]
  where
  { currentQuestion, currentAnswer } = inProgressState

  renderCard children =
    -- TODO: Card could be react component
    R.div
      { className: "card bg-base-100 shadow-xl bg-base-200 max-w-2xl mx-4"
      , key: show $ _.name $ un Fun $ currentQuestion.optionA
      , children:
          [ R.div
              { className: "card-body items-center text-center gap-0 z-10", children }
          , icon
              (languageIcon language)
              { size: "96px", className: "absolute m-6 text-base-300 z-0" }
          ]
      }

  -- TODO: Format function (maybe different colors)
  -- TODO: Make sure long function breaks accordingly or is prettified with line breaks
  renderQuestion q = h1
    { className: "font-mono font-medium text-xl w-full mb-6 sm:text-2xl sm:h-24 sm:mt-10"
    , children: [ R.text $ un Fun >>> _.signature $ questionFunction q ]
    }

  renderAnswerButton option fun =
    button_
      { color: case currentAnswer of
          Just answer | answer == option && option /= currentQuestion.correctOption -> "error"
          Just _ | option == currentQuestion.correctOption -> "success"
          _ -> "default"
      , onClick: handler stopPropagation $ const $
          if isJust currentAnswer then pure unit
          else onAnswerClick option
      , className: "gap-4 m-2 w-64 justify-start flex-nowrap"
      , children:
          [ element badge
              { size: "lg"
              , responsive: false
              , color: case currentAnswer of
                  Just answer | answer == option || option == currentQuestion.correctOption -> "neutral"
                  _ -> "secondary"
              , children: [ R.text $ show option ]
              }
          , let
              name = _.name $ un Fun fun
            in
              code
                { className: "font-medium font-mono text-lg normal-case truncate"
                , title: name
                , children: [ R.text name ]
                }
          ]
      }

