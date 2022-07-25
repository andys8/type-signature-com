module Components.AppNavbar where

import Foreign.Daisyui (navbar, navbarStart)
import Foreign.Logo (logoSmall)
import React.Basic (JSX, element)
import React.Basic.DOM as R

appNavbar :: JSX
appNavbar = element navbar
  { className: "shadow-md bg-neutral text-neutral-content z-50"
  , children:
      [ element navbarStart
          { className: "px-2 mx-2"
          , children:
              [ R.a
                  { className: "flex flex-row items-center text-lg font-bold gap-2"
                  , href: "/"
                  , children:
                      [ R.img { src: logoSmall, height: "32px", width: "32px" }
                      , R.text "Type-Signature"
                      ]
                  }
              ]
          }
      ]
  }
