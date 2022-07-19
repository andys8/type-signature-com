module Components.PageGameInProgress (pageGameInProgress) where

import Prelude

import Components.AppGameSteps (appGameSteps)
import Data.Maybe (Maybe(..), fromMaybe, isJust)
import Data.Newtype (un)
import Data.String (Pattern(..), split)
import Data.String as S
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
  R.div
    { className: "flex flex-col h-full w-full gap-8 items-center justify-start sm:justify-center"
    , children:
        [ appGameSteps { inProgressState }
        , renderCard cardContent
        ]
    }
  where
  { currentQuestion, currentAnswer } = inProgressState
  { correctOption } = currentQuestion

  cardContent =
    [ R.h2
        { className: "card-title text-secondary whitespace-nowrap"
        , children: [ R.text "Which function has this type?" ]
        }
    , renderQuestion currentQuestion
    , R.div_
        [ renderAnswerButton A currentQuestion.optionA
        , renderAnswerButton B currentQuestion.optionB
        , renderAnswerButton C currentQuestion.optionC
        , renderAnswerButton D currentQuestion.optionD
        ]
    ]

  renderCard children =
    R.div
      { className: "card flex-1 sm:flex-initial	h-1/2 shadow-xl bg-base-200 mx-2 w-full max-w-2xl"
      , key: show $ _.name $ un Fun $ currentQuestion.optionA
      , children:
          [ R.div
              { className: "card-body justify-between items-center text-center gap-4 z-10", children }
          , icon
              (languageIcon language)
              { size: "80px", className: "absolute m-6 text-base-300 z-0" }
          ]
      }

  renderQuestion q = R.div
    { className: "flex flex-col justify-center items-center w-full"
    , children:
        [ h1
            { className: "flex flex-col gap-2 font-mono font-medium text-xl sm:text-2xl"
            , children: [ renderSignature $ questionFunction q ]
            }
        ]
    }

  renderSignature (Fun { signature }) =
    case split (Pattern "=>") signature of
      [ a, b ] -> fragment
        [ renderConstraint (a <> "=>"), R.text b ]
      [ a, b, c ] -> fragment
        [ renderConstraint (a <> "=>"), renderConstraint (b <> "=>"), R.text c ]
      _ -> R.text signature

  renderConstraint a = R.span { className: "opacity-50", children: [ R.text a ] }

  renderAnswerButton option fun =
    button_
      { color: case currentAnswer of
          Just answer | answer == option && option /= correctOption -> "error"
          Just _ | option == correctOption -> "success"
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
                  Just answer | answer == option || option == correctOption -> "neutral"
                  _ -> "secondary"
              , children: [ R.text $ show option ]
              }
          , code
              { className: "font-medium font-mono text-lg normal-case truncate"
              , title: functionName fun
              , children: [ R.text $ noParens $ functionName fun ]
              }
          ]
      }

functionName :: Fun -> String
functionName = _.name <<< un Fun

noParens :: String -> String
noParens x = fromMaybe x (S.stripPrefix (Pattern "(") =<< (S.stripSuffix (Pattern ")") x))
