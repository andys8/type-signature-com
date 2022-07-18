module Components.PageStart (pageStart) where

import Prelude

import Data.String (joinWith)
import Effect (Effect)
import Foreign.Daisyui (button, buttonGroup)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Icons (icon, icon_)
import React.Icons.Gi (giPencilBrush)
import React.Icons.Si (siElm, siHaskell, siPurescript)
import React.Icons.Vsc (vscDebugStart)
import State (Language(..))

type Props =
  { onStartClick :: Effect Unit
  , onLanguageSet :: Language -> Effect Unit
  , language :: Language
  }

pageStart :: Props -> JSX
pageStart { onStartClick, onLanguageSet, language } =
  fragment
    [ icon
        giPencilBrush
        { size: "120px", className: "m-4" }
    , R.h1
        { className: "text-5xl font-bold"
        , children: [ R.text "type-signature" ]
        }
    , R.p
        { className: "py-6"
        , children: [ R.text "Who Wants to Be a Millionaire - but with types" ]
        }
    , languageSelection { language, onLanguageSet }
    , element button
        { color: "primary"
        , onClick: handler_ onStartClick
        , disabled: false
        , key: "start"
        , className: "mt-8 gap-2"
        , children: [ icon_ vscDebugStart, R.text "Start" ]
        }
    ]

languageSelection :: { language :: Language, onLanguageSet :: Language -> Effect Unit } -> JSX
languageSelection { language, onLanguageSet } =
  element buttonGroup
    { children:
        [ element button
            { color: "default"
            , onClick: handler_ $ onLanguageSet Haskell
            , disabled: false
            , key: "Haskell" <> show (Haskell == language)
            , className: classes Haskell
            , children: [ icon siHaskell { size: "24px" }, R.text "Haskell" ]
            }
        , element button
            { color: "default"
            , onClick: handler_ $ onLanguageSet PureScript
            , disabled: false
            , key: "PureScript" <> show (PureScript == language)
            , className: classes PureScript
            , children: [ icon siPurescript { size: "24px" }, R.text "PureScript" ]
            }
        , element button
            { color: "default"
            , onClick: handler_ $ onLanguageSet Elm
            , disabled: false
            , key: "Elm" <> show (Elm == language)
            , className: classes Elm
            , children: [ icon siElm { size: "24px" }, R.text "Elm" ]
            }
        ]
    }
  where
  classes l = joinWith " " [ "flex-col gap-2 w-28 h-20", opactiy l ]
  opactiy l = if l == language then "opacity-100" else "opacity-50"
