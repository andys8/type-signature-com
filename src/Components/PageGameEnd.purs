module Components.PageGameEnd (pageGameEnd) where

import Prelude

import Data.Array ((:))
import Data.Array as A
import Data.Int (toNumber)
import Data.Monoid (guard)
import Data.String (joinWith)
import Foreign.Daisyui (button_, stat, statItem, stats)
import Functions (Fun(..))
import Languages (Language, languageIcon)
import Questions (AnsweredQuestion(..), isAnswerCorrect, questionFunction)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM as R
import React.Basic.DOM.Events (stopPropagation)
import React.Basic.Events (EventHandler, handler)
import React.Icons (icon, icon_)
import React.Icons.Fa (faTwitter)
import React.Icons.Gi (giRibbonMedal)
import React.Icons.Im (imCheckmark, imCross)
import React.Icons.Vsc (vscDebugRestart)
import Web.HTML (window)
import Web.HTML.Window as Window

type Props =
  { answeredQuestions :: Array AnsweredQuestion
  , onRestart :: EventHandler
  , language :: Language
  }

pageGameEnd :: Props -> JSX
pageGameEnd { answeredQuestions, onRestart, language } =
  fragment
    [ icon (languageIcon language)
        { size: "64px"
        , className: "text-base-300 my-6"
        }
    , resultStat
    , renderQuestions answeredQuestions
    , R.div
        { className: "flex flex-row gap-4"
        , children: restartButton : guard (score > 0.5) [ twitterButton ]
        }
    ]
  where
  restartButton =
    button_
      { color: "default"
      , onClick: onRestart
      , className: "gap-2"
      , children: [ icon_ vscDebugRestart, R.text "Try again" ]
      }

  twitterButton =
    button_
      { color: "info"
      , className: "gap-2"
      , onClick: handler stopPropagation $ const $ do
          let url = "https://twitter.com/intent/tweet?text=" <> tweet
          void $ Window.open url "_blank" "" =<< window
      , children: [ icon_ faTwitter, R.text "Tweet about it" ]
      }

  tweet = joinWith " "
    [ "Hey there, I scored"
    , show countCorrect <> "/" <> show countTotal
    , "with " <> show language
    , "on type-signature.com."
    , "Give it a shot yourself!"
    ]

  resultStat = element stats
    { className: "bg-primary text-primary-content shadow px-4"
    , children:
        [ element stat
            { children:
                [ element statItem
                    { variant: "title"
                    , children: [ R.text "Result" ]
                    }
                , element statItem
                    { variant: "value"
                    , children:
                        [ R.span { className: "text-9xl font-bold", children: [ R.text $ show countCorrect ] }
                        , R.span { className: "text-5xl", children: [ R.text "/" ] }
                        , R.span { className: "text-3xl", children: [ R.text $ show countTotal ] }
                        ]
                    }
                , element statItem
                    { variant: "desc"
                    , children: [ R.text statText ]
                    }
                , icon giRibbonMedal
                    { size: "120px"
                    , color: "white"
                    , className: "absolute -mt-[30px] -ml-[86px] z-50"
                    }
                ]
            }
        ]
    }

  statText | score > 0.8 = "Impressive"
  statText | score > 0.5 = "Well done"
  statText | score > 0.0 = "Good start"
  statText = "Don't give up!"

  countTotal = A.length answeredQuestions
  countCorrect = A.length $ A.filter isAnswerCorrect answeredQuestions
  score = toNumber countCorrect / toNumber countTotal

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
    R.thead
      { className: "hidden sm:table-header-group"
      , children:
          [ R.tr_
              [ R.th_ []
              , R.th_ [ R.text "Name" ]
              , R.th_ [ R.text "Signature" ]
              ]
          ]
      }
  body = R.tbody_ (R.tr_ <<< renderQuestion <$> A.reverse questions)

renderQuestion :: AnsweredQuestion -> Array JSX
renderQuestion aq@(AnsweredQuestion question _) =
  [ R.th { className: "py-0.5 pr-1 sm:pr-3", children: [ answerIcon ] }
  , R.td { className: "py-0.5 pr-1 font-bold sm:pr-3", children: [ R.text name ] }
  , R.td
      { className: "hidden py-0.5 pr-1 sm:table-cell sm:pr-3"
      , children:
          [ R.pre
              { className: "truncate max-w-lg"
              , title: signature
              , children: [ R.text signature ]
              }
          ]
      }
  ]
  where
  Fun { name, signature } = questionFunction question
  answerIcon =
    if isAnswerCorrect aq then icon imCheckmark { className: "text-success" }
    else icon imCross { className: "text-error" }

