module Components.AppNavbar where

import Foreign.Daisyui (navbar, navbarStart)
import React.Basic (JSX, element)
import React.Basic.DOM as R
import React.Icons (icon)
import React.Icons.Gi (giPencilBrush)

appNavbar :: JSX
appNavbar = element navbar
  { className: "shadow-md bg-neutral text-neutral-content"
  , children:
      [ element navbarStart
          { className: "px-2 mx-2"
          , children:
              [ R.a
                  { className: "flex flex-row items-center text-lg font-bold gap-4"
                  , href: "/"
                  , children:
                      [ icon giPencilBrush { size: "24px" }
                      , R.text "type-signature.com"
                      ]
                  }
              ]
          }
      ]
  }
