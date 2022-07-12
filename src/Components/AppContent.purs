module Components.AppContent where

import Foreign.Daisyui (hero, heroContent)
import React.Basic (JSX, element)
import React.Basic.DOM as R

appContent :: JSX -> JSX
appContent content = element hero
  { className: "bg-base-400"
  , children:
      [ element heroContent
          { className: "text-center"
          , children:
              [ R.div
                  { className: "max-w-md flex flex-col items-center"
                  , children: [ content ]
                  }
              ]
          }
      ]
  }