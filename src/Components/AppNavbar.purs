module Components.AppNavbar where

import Foreign.Daisyui (navbar, navbarStart)
import Foreign.Logo (logoSmall)
import React.Basic (JSX, element)
import React.Basic.DOM as R

appNavbar :: JSX
appNavbar = element navbar
  { className: "z-50 shadow-md bg-neutral"
  , children:
      [ element navbarStart
          { className: "flex flex-row items-center justify-between mx-3"
          , children:
              [ R.a
                  { href: "/"
                  , children:
                      [ R.span
                          { className: "text-xl font-semibold whitespace-nowrap text-base-content"
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
