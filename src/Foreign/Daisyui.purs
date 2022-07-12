module Foreign.Daisyui where

import React.Basic.Events (EventHandler)
import React.Basic.Hooks (JSX, ReactComponent)

foreign import button
  :: ReactComponent
       { color :: String
       , onClick :: EventHandler
       , disabled :: Boolean
       , children :: Array JSX
       }

foreign import footer
  :: ReactComponent
       { className :: String
       , children :: Array JSX
       }

foreign import footerTitle :: ReactComponent { children :: Array JSX }

foreign import hero :: ReactComponent { className :: String, children :: Array JSX }
foreign import heroOverlay :: ReactComponent { className :: String, children :: Array JSX }
foreign import heroContent :: ReactComponent { className :: String, children :: Array JSX }

foreign import navbar :: ReactComponent { className :: String, children :: Array JSX }
foreign import navbarStart :: ReactComponent { className :: String, children :: Array JSX }
foreign import navbarCenter :: ReactComponent { className :: String, children :: Array JSX }
foreign import navbarEnd :: ReactComponent { className :: String, children :: Array JSX }
