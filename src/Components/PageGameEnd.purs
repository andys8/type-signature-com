module Components.PageGameEnd (mkPageGameEnd) where

import Prelude

import Data.Array ((:))
import Data.Array as A
import Data.DateTime.Instant (Instant, unInstant)
import Data.Int (round)
import Data.Maybe (Maybe(..))
import Data.Monoid (guard)
import Data.String (joinWith)
import Data.Time.Duration (Seconds(..), negateDuration, toDuration)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Now (now)
import Foreign.Daisyui (badge, button_, stat, statItem, stats)
import Foreign.ReactHotkeysHook (useHotkeys)
import Functions (Fun(..))
import Languages (Language(..), languageIcon)
import Questions (AnsweredQuestion(..), isAnswerCorrect, questionFunction, toStat)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM as R
import React.Basic.DOM.Events (stopPropagation)
import React.Basic.Events (handler, handler_)
import React.Basic.Hooks (Component, component)
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
import React.Icons (icon, icon_)
import React.Icons.Fa (faTwitter)
import React.Icons.Gi (giRibbonMedal, giSpeedometer)
import React.Icons.Im (imCheckmark, imCross)
import React.Icons.Vsc (vscDebugRestart)
import Record as Record
import State (GameEndState)
import Web.HTML (window)
import Web.HTML.Window as Window

type Props = Record Props_

type Props_ =
  ( gameEndState :: GameEndState
  , language :: Language
  , onRestart :: Effect Unit
  , onHaskellLensMode :: Effect Unit
  )

type WithCurrentTime a = { currentTime :: Maybe Instant | a }

mkPageGameEnd :: Component Props
mkPageGameEnd =
  component "PageGameEnd" \props@{ onRestart } -> React.do
    useHotkeys "space, return, t" onRestart
    currentTime <- useAff unit $ liftEffect now
    pure $ pageGameEnd $ Record.merge props { currentTime }

pageGameEnd :: WithCurrentTime Props_ -> JSX
pageGameEnd { gameEndState, onRestart, onHaskellLensMode, language, currentTime } =
  fragment
    [ resultStat
    , renderTable answeredQuestions
    , buttons
    , icon (languageIcon language) { size: "32px", className: "mt-6 text-base-300" }
    ]
  where
  { answeredQuestions, startTime } = gameEndState
  { countTotal, countCorrect, score } = toStat answeredQuestions

  renderSeconds (Seconds s) = show (round s) <> " seconds"
  duration = toDurationDiff startTime currentTime

  buttons = R.div
    { className: "flex flex-col sm:flex-row gap-4"
    , children:
        restartButton
          : guard (isPerfectResult && language == Haskell) [ haskellLensModeButton ]
          <> guard (score > 0.5) [ twitterButton ]
    }

  restartButton =
    button_
      { color: "default"
      , onClick: handler_ onRestart
      , className: "justify-start gap-2"
      , children: [ icon_ vscDebugRestart, R.text "Try again" ]
      }

  twitterButton =
    button_
      { color: "info"
      , className: "justify-start gap-2"
      , onClick: handler stopPropagation $ const $ do
          let
            url = "https://twitter.com/intent/tweet"
              <> "?via=_andys8"
              <> ("&hashtags=" <> show language)
              <> ("&text=" <> tweet)
          void $ Window.open url "_blank" "" =<< window
      , children: [ icon_ faTwitter, R.text "Share on Twitter" ]
      }

  tweet = joinWith " "
    [ "Hey there, I scored"
    , show countCorrect <> "/" <> show countTotal
    , "on https://type-signature.com."
    , "Give it a shot!"
    ]

  haskellLensModeButton =
    button_
      { color: "accent"
      , onClick: handler_ onHaskellLensMode
      , className: "justify-start gap-2"
      , children: [ icon_ $ languageIcon HaskellLens, R.text "Kmett Mode" ]
      }

  statText | score > 0.8 = case duration of
    Just d | d <= Seconds 30.0 -> "Crazy, only " <> renderSeconds d <> "!"
    Just d | d <= Seconds 60.0 -> "Wow, only " <> renderSeconds d <> "!"
    _ -> "Impressive"
  statText | score > 0.5 = "Well done"
  statText | score > 0.0 = "Good start"
  statText = "Don't give up!"

  isPerfectResult = case duration of
    Just d -> d <= Seconds 30.0 && score == 1.0
    _ -> false

  statTitle | isPerfectResult = speedRunBadge
  statTitle = R.text "Result"

  speedRunBadge = element badge
    { size: "md"
    , responsive: false
    , color: "neutral"
    , className: "gap-1"
    , children: [ icon_ giSpeedometer, R.text "Speedrun" ]
    }

  resultStat = element stats
    { className: joinWith " "
        [ "shadow px-4 select-none animate-fadein"
        , if score == 1.0 then "bg-success text-success-content"
          else if score > 0.5 then "bg-primary text-primary-content"
          else "bg-secondary text-secondary-content"
        ]
    , children:
        [ element stat
            { children:
                [ element statItem
                    { variant: "title"
                    , children: [ statTitle ]
                    }
                , element statItem
                    { variant: "value"
                    , children:
                        [ R.span { className: "font-bold text-9xl", children: [ R.text $ show countCorrect ] }
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

renderTable :: Array AnsweredQuestion -> JSX
renderTable questions = R.div
  { className: "my-6 overflow-x-auto shadow"
  , children: [ R.table { className: "table w-full", children: [ header, body ] } ]
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
  body = R.tbody_ (R.tr_ <<< renderTableRow <$> A.reverse questions)

renderTableRow :: AnsweredQuestion -> Array JSX
renderTableRow aq@(AnsweredQuestion question _) =
  [ R.th { className: "py-0.5 pr-1 sm:pr-3", children: [ answerIcon ] }
  , R.td { className: "py-0.5 pr-1 font-bold sm:pr-3", children: [ R.text name ] }
  , R.td
      { className: "hidden py-0.5 pr-1 sm:table-cell sm:pr-3"
      , children:
          [ R.pre
              { className: "max-w-lg font-mono font-medium truncate"
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

toDurationDiff :: Instant -> Maybe Instant -> Maybe Seconds
toDurationDiff start (Just end) = Just $ toDuration $ unInstant end <> negateDuration (unInstant start)
toDurationDiff _ Nothing = Nothing
