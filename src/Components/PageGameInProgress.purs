module Components.PageGameInProgress (pageGameInProgress) where

import Prelude

import Foreign.Daisyui (button, hero, heroContent)
import React.Basic (JSX, element)
import React.Basic.DOM as R
import React.Basic.Events (EventHandler)
import State (GameInProgressState)

type Props =
  { onAnswerClick :: EventHandler
  , inProgressState :: GameInProgressState
  }

pageGameInProgress :: Props -> JSX
pageGameInProgress { onAnswerClick, inProgressState } = element hero
  { className: "bg-base-400"
  , children:
      [ element heroContent
          { className: "text-center"
          , children:
              [ R.div
                  { className: "max-w-md flex flex-col items-center"
                  , children:
                      [ R.text (show inProgressState)
                      , element button
                          { color: "default"
                          , onClick: onAnswerClick
                          , disabled: false
                          , children: [ R.text "Answer" ]
                          }
                      ]
                  }
              ]
          }
      ]
  }
