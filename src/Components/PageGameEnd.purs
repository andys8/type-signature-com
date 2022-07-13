module Components.PageGameEnd (pageGameEnd) where

import Foreign.Daisyui (button)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM as R
import React.Basic.Events (EventHandler)
import React.Icons (icon)
import React.Icons.Gi (giRibbonMedal)

type Props =
  { onRestart :: EventHandler
  }

pageGameEnd :: Props -> JSX
pageGameEnd { onRestart } =
  fragment
    [ R.h1
        { className: "text-2xl font-bold"
        , children: [ R.text "End" ]
        }
    , icon giRibbonMedal { size: "120px", className: "m-10" }
    , element button
        { color: "default"
        , onClick: onRestart
        , disabled: false
        , className: ""
        , children: [ R.text "New Game" ]
        }
    ]
