module Components.PageStart (pageStart) where

import Prelude

import Data.Array.NonEmpty as NEA
import Data.String (joinWith)
import Effect (Effect)
import Foreign.Daisyui (button_, buttonGroup)
import Foreign.Logo (logoLarge)
import Languages (Language, languageIcon, languages)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Icons (icon, icon_)
import React.Icons.Vsc (vscDebugStart)

type Props =
  { onStartClick :: Effect Unit
  , onLanguageSet :: Language -> Effect Unit
  , language :: Language
  }

pageStart :: Props -> JSX
pageStart { onStartClick, onLanguageSet, language } =
  fragment
    [ R.img { src: logoLarge, width: "360px", height: "360px", className: "animate-fadein pb-8" }
    , languageSelection { language, onLanguageSet }
    , button_
        { color: "primary"
        , onClick: handler_ onStartClick
        , key: "start"
        , className: "mt-8 gap-2"
        , children: [ icon_ vscDebugStart, R.text "Start" ]
        }
    ]

languageSelection :: { language :: Language, onLanguageSet :: Language -> Effect Unit } -> JSX
languageSelection { language, onLanguageSet } =
  element buttonGroup { children: NEA.toArray $ languageButton <$> languages }
  where
  classes l = joinWith " " [ "flex-col gap-2 min-w-fit w-24 h-20", opactiy l ]
  opactiy l = if l == language then "opacity-100" else "opacity-50"
  languageButton l =
    button_
      { color: if l == language then "secondary" else "default"
      , onClick: handler_ $ onLanguageSet l
      , key: joinWith "-" [ show l, show (l == language) ]
      , className: classes l
      , animation: false
      , children:
          [ icon (languageIcon l) { size: "24px" }
          , R.text $ show l
          ]
      }
