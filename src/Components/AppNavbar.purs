module Components.AppNavbar where

import Foreign.Daisyui (navbar, navbarStart)
import React.Basic (JSX, element)
import React.Basic.DOM as R

appNavbar :: JSX
appNavbar = element navbar
  { className: "shadow-md bg-neutral text-neutral-content"
  , children:
      [ element navbarStart
          { className: "px-2 mx-2"
          , children:
              [ R.span
                  { className: "text-lg font-bold"
                  , children: [ R.text "type-signature.com" ]
                  }
              ]
          }
      ]
  }
