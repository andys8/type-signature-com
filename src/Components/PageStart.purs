module Components.PageStart (pageStart) where

import Foreign.Daisyui (button)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM as R
import React.Basic.Events (EventHandler)
import React.Icons (icon)
import React.Icons.Gi (giPencilBrush)

type Props =
  { isLoading :: Boolean
  , onStartClick :: EventHandler
  }

pageStart :: Props -> JSX
pageStart { onStartClick, isLoading } =
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
        , disabled: isLoading
        , className: "focus:outline-none"
        , children: [ R.text "Start" ]
        }
    ]
