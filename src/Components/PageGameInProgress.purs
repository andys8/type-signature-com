module Components.PageGameInProgress (mkPageGameInProgress) where

import Prelude

import Components.AppGameSteps (appGameSteps)
import Data.Maybe (Maybe(..), fromMaybe, isJust, isNothing)
import Data.Monoid (guard)
import Data.Newtype (un)
import Data.String (Pattern(..), split)
import Data.String as S
import Effect (Effect)
import Foreign.Daisyui (badge, button_)
import Foreign.ReactHotkeysHook (useHotkeys)
import Functions (Fun(..))
import Languages (Language, languageIcon)
import Questions (Answer, Option(..), questionFunction)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM (code, h1)
import React.Basic.DOM as R
import React.Basic.DOM.Events (stopPropagation)
import React.Basic.Events (handler)
import React.Basic.Hooks (Component, component)
import React.Basic.Hooks as React
import React.Icons (icon)
import State (GameInProgressState)

type Props =
  { language :: Language
  , inProgressState :: GameInProgressState
  , onAnswerClick :: Answer -> Effect Unit
  }

data OptionResult = OptionError | OptionCorrect | OptionDefault

derive instance Eq OptionResult

mkPageGameInProgress :: Component Props
mkPageGameInProgress =
  component "PageGameInProgress" \props@{ onAnswerClick } -> React.do
    useHotkeys "a" $ onAnswerClick A
    useHotkeys "b" $ onAnswerClick B
    useHotkeys "c" $ onAnswerClick C
    useHotkeys "d" $ onAnswerClick D
    pure $ pageGameInProgress props

pageGameInProgress :: Props -> JSX
pageGameInProgress { language, onAnswerClick, inProgressState } =
  R.div
    { className: "flex flex-col items-center justify-start w-full h-full gap-8 sm:justify-center"
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
        { className: "select-none card-title text-secondary whitespace-nowrap"
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
      { className: "flex-1 w-full max-w-2xl mx-2 shadow-xl card sm:flex-initial sm:min-h-[440px] bg-base-200"
      , key: show $ _.name $ un Fun $ currentQuestion.optionA
      , children:
          [ R.div
              { className: "z-10 items-center justify-between text-center card-body gap-4", children }
          , icon
              (languageIcon language)
              { size: "80px", className: "absolute z-0 m-6 text-base-300" }
          ]
      }

  renderQuestion q = R.div
    { className: "flex flex-col items-center justify-center w-full"
    , children:
        [ h1
            { className: "flex flex-col font-mono text-xl font-medium gap-2 sm:text-2xl"
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

  renderConstraint a = R.span { className: "opacity-70", children: [ R.text a ] }

  optionResult option =
    case currentAnswer of
      Just answer | answer == option && option /= correctOption -> OptionError
      Just _ | option == correctOption -> OptionCorrect
      _ -> OptionDefault

  renderAnswerButton option fun =
    button_
      { color: case optionResult option of
          OptionError -> "error"
          OptionCorrect -> "success"
          OptionDefault -> "default"
      , onClick: handler stopPropagation
          $ const
          $ when (isNothing currentAnswer)
          $ onAnswerClick option
      , className: "justify-start w-64 m-2 gap-4 flex-nowrap"
          <> guard (isJust currentAnswer) " pointer-events-none"
          <> guard (optionResult option == OptionError) " animate-wiggle"
      , children:
          [ element badge
              { size: "lg"
              , responsive: false
              , color: case optionResult option of
                  OptionDefault -> "secondary"
                  _ -> "neutral"
              , children: [ R.text $ show option ]
              }
          , code
              { className: "font-mono text-lg font-medium normal-case truncate"
              , title: functionName fun
              , children: [ R.text $ noParens $ functionName fun ]
              }
          ]
      }

functionName :: Fun -> String
functionName = _.name <<< un Fun

noParens :: String -> String
noParens x = fromMaybe x (S.stripPrefix (Pattern "(") =<< (S.stripSuffix (Pattern ")") x))
