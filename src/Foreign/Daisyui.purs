module Foreign.Daisyui where

import React.Basic.Events (EventHandler)
import React.Basic.Hooks (JSX, ReactComponent)

foreign import button
  :: ReactComponent
       { color :: String
       , className :: String
       , key :: String
       , onClick :: EventHandler
       , disabled :: Boolean
       , children :: Array JSX
       }

foreign import footer :: ReactComponent { className :: String, children :: Array JSX }
foreign import footerTitle :: ReactComponent { children :: Array JSX }

foreign import hero :: ReactComponent { className :: String, children :: Array JSX }
foreign import heroOverlay :: ReactComponent { className :: String, children :: Array JSX }
foreign import heroContent :: ReactComponent { className :: String, children :: Array JSX }

foreign import navbar :: ReactComponent { className :: String, children :: Array JSX }
foreign import navbarStart :: ReactComponent { className :: String, children :: Array JSX }
foreign import navbarCenter :: ReactComponent { className :: String, children :: Array JSX }
foreign import navbarEnd :: ReactComponent { className :: String, children :: Array JSX }

foreign import kbd :: ReactComponent { className :: String, children :: Array JSX }
foreign import badge
  :: ReactComponent
       { color :: String
       , size :: String
       , responsive :: Boolean
       , children :: Array JSX
       }

foreign import progress :: ReactComponent { className :: String }

foreign import alert :: ReactComponent { status :: String, children :: Array JSX }

foreign import codeMockup :: ReactComponent { children :: Array JSX }

foreign import stats :: ReactComponent { className :: String, children :: Array JSX }
foreign import stat :: ReactComponent { children :: Array JSX }
foreign import statItem :: ReactComponent { variant :: String, children :: Array JSX }

foreign import select :: ReactComponent { initialValue :: String, className :: String, children :: Array JSX }
foreign import selectOption :: ReactComponent { value :: String, children :: Array JSX }

foreign import buttonGroup :: ReactComponent { children :: Array JSX }
