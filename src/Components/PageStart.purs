module Components.PageStart (pageStart) where

import Foreign.Daisyui (button)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM as R
import React.Basic.Events (EventHandler)
import React.Icons (icon, icon_)
import React.Icons.Gi (giPencilBrush)
import React.Icons.Vsc (vscDebugStart)

type Props =
  { onStartClick :: EventHandler
  }

pageStart :: Props -> JSX
pageStart { onStartClick } =
  fragment
    [ icon
        giPencilBrush
        { size: "120px", className: "m-4" }
    , R.h1
        { className: "text-5xl font-bold"
        , children: [ R.text "type-signature" ]
        }
    , R.p
        { className: "py-6"
        , children: [ R.text "Who Wants to Be a Millionaire - but with types" ]
        }
    , element button
        { color: "default"
        , onClick: onStartClick
        , disabled: false
        , className: "gap-2"
        , children: [ icon_ vscDebugStart, R.text "Start" ]
        }
    ]
