module Components.PageGameEnd (pageGameEnd) where

import Prelude

import Data.Array as A
import Foreign.Daisyui (button, stat, statItem, stats)
import Questions (AnsweredQuestion, isAnswerCorrect)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM as R
import React.Basic.Events (EventHandler)
import React.Icons (icon, icon_)
import React.Icons.Gi (giRibbonMedal)
import React.Icons.Vsc (vscDebugRestart)

type Props =
  { answeredQuestions :: Array AnsweredQuestion
  , onRestart :: EventHandler
  }

pageGameEnd :: Props -> JSX
pageGameEnd { answeredQuestions, onRestart } =
  fragment
    [ resultStat
    , icon giRibbonMedal { size: "120px", className: "m-10" }
    , element button
        { color: "default"
        , onClick: onRestart
        , disabled: false
        , className: "gap-2"
        , children: [ icon_ vscDebugRestart, R.text "Try again" ]
        }
    ]
  where
  resultStat = element stats
    { className: "bg-primary text-primary-content shadow px-4"
    , children:
        [ element stat
            { children:
                [ element statItem { variant: "title", children: [ R.text "Result" ] }
                , element statItem
                    { variant: "value"
                    , children:
                        [ R.span { className: "text-9xl font-bold", children: [ R.text $ show countCorrect ] }
                        , R.span { className: "text-5xl", children: [ R.text "/" ] }
                        , R.span { className: "text-3xl", children: [ R.text $ show countTotal ] }
                        ]
                    }
                , element statItem { variant: "desc", children: [ R.text "Impressive" ] }
                ]
            }
        ]
    }
  countTotal = A.length answeredQuestions
  countCorrect = A.length $ A.filter isAnswerCorrect answeredQuestions
