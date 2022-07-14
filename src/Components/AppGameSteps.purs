module Components.AppGameSteps where

import Prelude

import Data.Maybe (Maybe(..), isJust)
import Data.Newtype (un)
import Effect (Effect)
import Foreign.Daisyui (badge, button)
import Functions (Fun(..))
import Questions (Option(..), Answer)
import React.Basic (JSX, element, fragment)
import React.Basic.DOM (code, h1)
import React.Basic.DOM as R
import React.Basic.DOM.Events (stopPropagation)
import React.Basic.Events (handler)
import React.Icons (icon, icon_)
import React.Icons.Fa (faCheck)
import React.Icons.Im (imCheckmark, imCross)
import State (GameInProgressState)

type Props =
  { inProgressState :: GameInProgressState
  }

appGameSteps :: Props -> JSX
appGameSteps { inProgressState } =
  R.ul
    { className: "steps py-10 font-medium"
    , children:
        [ R.li { className: "step step-neutral", children: [ icon imCheckmark { className: "text-success" } ] }
        , R.li { className: "step step-neutral", children: [ icon imCross { className: "text-error" } ] }
        , R.li { className: "step step-neutral", children: [] }
        , R.li { className: "step", children: [] }
        , R.li { className: "step", children: [] }
        , R.li { className: "step", children: [] }
        ]
    }
