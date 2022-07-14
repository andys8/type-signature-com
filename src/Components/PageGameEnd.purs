module Components.PageGameEnd (pageGameEnd) where

import Prelude

import Data.Array as A
import Foreign.Daisyui (button, stat, statItem, stats)
import Functions (Fun(..))
import Questions (AnsweredQuestion(..), isAnswerCorrect, questionFunction)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM as R
import React.Basic.Events (EventHandler)
import React.Icons (icon, icon_)
import React.Icons.Gi (giRibbonMedal)
import React.Icons.Im (imCheckmark, imCross)
import React.Icons.Vsc (vscDebugRestart)

type Props =
  { answeredQuestions :: Array AnsweredQuestion
  , onRestart :: EventHandler
  }

pageGameEnd :: Props -> JSX
pageGameEnd { answeredQuestions, onRestart } =
  fragment
    [ resultStat
    , renderQuestions answeredQuestions
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
                , icon giRibbonMedal
                    { size: "120px"
                    , color: "white"
                    , className: "absolute -mt-[30px] -ml-[86px] z-50"
                    }
                ]
            }
        ]
    }
  countTotal = A.length answeredQuestions
  countCorrect = A.length $ A.filter isAnswerCorrect answeredQuestions

renderQuestions :: Array AnsweredQuestion -> JSX
renderQuestions questions = R.div
  { className: "overflow-x-auto my-10"
  , children:
      [ R.table
          { className: "table w-full"
          , children: [ header, body ]
          }
      ]
  }
  where
  header =
    R.thead_
      [ R.tr_
          [ R.th_ []
          , R.th_ [ R.text "Name" ]
          , R.th_ [ R.text "Signature" ]
          ]
      ]
  body = R.tbody_ (R.tr_ <<< renderQuestion <$> questions)

renderQuestion :: AnsweredQuestion -> Array JSX
renderQuestion aq@(AnsweredQuestion question _) =
  [ R.th { className: "pr-4", children: [ answerIcon ] }
  , R.td { className: "pr-4 font-bold", children: [ R.text name ] }
  , R.td_
      [ R.pre
          { className: "truncate max-w-md"
          , title: signature
          , children: [ R.text signature ]
          }
      ]
  ]
  where
  Fun { name, signature } = questionFunction question
  answerIcon =
    if isAnswerCorrect aq then icon imCheckmark { className: "text-success" }
    else icon imCross { className: "text-error" }

