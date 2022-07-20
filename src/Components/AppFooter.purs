module Components.AppFooter (appFooter) where

import Foreign.Daisyui (footer)
import React.Basic (JSX, element)
import React.Basic.DOM as R
import React.Icons (icon)
import React.Icons.Fa (faGithub, faTwitter)
import React.Icons.Types (ReactIcon)

appFooter :: JSX
appFooter = element footer
  { className: "p-6 footer footer-center gap-4 bg-base-200 text-base-content"
  , children:
      [ R.div
          { className: "grid grid-flow-col gap-4"
          , children:
              [ linkIcon "Github" faGithub "https://github.com/andys8/type-signature-com"
              , linkIcon "Twitter" faTwitter "https://twitter.com/_andys8"
              ]
          }
      , R.p_ [ R.text "Copyright © 2022 - type-signature.com" ]
      ]
  }

linkIcon :: String -> ReactIcon -> String -> JSX
linkIcon title reactIcon href =
  R.a
    { href
    , children: [ icon reactIcon { size: "24px", title } ]
    }
