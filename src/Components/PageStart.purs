module Components.PageStart (pageStart) where

import Foreign.Daisyui (button, hero, heroContent)
import React.Basic (JSX, element)
import React.Basic.DOM as R
import React.Basic.Events (EventHandler)
import React.Icons (icon)
import React.Icons.Gi (giPencilBrush)

type Props = { onStartClick :: EventHandler }

pageStart :: Props -> JSX
pageStart { onStartClick } = element hero
  { className: "bg-base-400"
  , children:
      [ element heroContent
          { className: "text-center"
          , children:
              [ R.div
                  { className: "max-w-md flex flex-col items-center"
                  , children:
                      [ icon giPencilBrush { size: "120px", className: "m-4" }
                      , R.h1
                          { className: "text-5xl font-bold"
                          , children: [ R.text "type-signature" ]
                          }
                      , R.p
                          { className: "py-6"
                          , children:
                              [ R.text "Who Wants to Be a Millionaire - but with types" ]
                          }
                      , element button
                          { color: "default"
                          , onClick: onStartClick
                          , children: [ R.text "Start" ]
                          }
                      ]
                  }
              ]
          }
      ]
  }
