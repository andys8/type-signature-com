module Components.AppFooter where

import Foreign.Daisyui (footer)
import React.Basic (JSX, element)
import React.Basic.DOM as R
import React.Icons (icon)
import React.Icons.Fa (faGithub, faTwitter)

appFooter :: JSX
appFooter = element footer
  { className: "footer footer-center p-6 gap-4 bg-base-200 text-base-content"
  , children:
      [ R.div_
          [ R.div
              { className: "grid grid-flow-col gap-4"
              , children:
                  [ R.a
                      { href: "https://github.com/andys8/type-signature-com"
                      , children: [ icon faGithub { size: "24px", title: "Github" } ]
                      }
                  , R.a
                      { href: "https://twitter.com/_andys8"
                      , children: [ icon faTwitter { size: "24px", title: "Twitter" } ]
                      }
                  ]
              }
          ]
      , R.div_ [ R.p_ [ R.text "Copyright © 2022 - type-signature.com" ] ]
      ]
  }
