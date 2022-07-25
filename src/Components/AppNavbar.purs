module Components.AppNavbar where

import Foreign.Daisyui (navbar, navbarStart)
import Foreign.Logo (logoSmall)
import React.Basic (JSX, element)
import React.Basic.DOM as R

appNavbar :: JSX
appNavbar = element navbar
  { className: "shadow-md bg-neutral text-primary z-50"
  , children:
      [ element navbarStart
          { className: "flex flex-row items-center justify-between mx-3"
          , children:
              [ R.a
                  { href: "/"
                  , children:
                      [ R.span
                          { className: "text-xl font-semibold whitespace-nowrap text-white"
                          , children: [ R.text "type-signature.com" ]
                          }
                      ]
                  }
              , R.img
                  { src: logoSmall, height: "32px", width: "32px" }
              ]
          }
      ]
  }
