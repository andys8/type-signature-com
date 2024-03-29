module Components.PageStart (mkPageStart) where

import Prelude

import Data.String (joinWith)
import Effect (Effect)
import Foreign.Daisyui (button_)
import Foreign.Logo (logoLarge)
import Foreign.ReactHotkeysHook (useHotkeys)
import Languages (Language(..), languageIcon)
import React.Basic (JSX, fragment)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component)
import React.Basic.Hooks as React
import React.Icons (icon, icon_)
import React.Icons.Vsc (vscDebugStart)

type Props =
  { onStartClick :: Effect Unit
  , onLanguageSet :: Language -> Effect Unit
  , language :: Language
  }

mkPageStart :: Component Props
mkPageStart =
  component "PageStart" \props@{ onStartClick, onLanguageSet } -> React.do
    useHotkeys "space, return, s" onStartClick
    useHotkeys "h" (onLanguageSet Haskell)
    useHotkeys "p" (onLanguageSet PureScript)
    useHotkeys "e" (onLanguageSet Elm)
    pure $ pageStart props

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
  R.div
    { className: "flex flex-row flex-nowrap btn-group"
    , children: languageButton <$> [ Haskell, PureScript, Elm ]
    }
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
