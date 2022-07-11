module Main where

import Prelude

import Data.Functions (haskellBaseUrl, loadFunctions)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import Effect.Exception (throw)
import Foreign.Daisyui (button, footer, hero, heroContent, navbar, navbarStart)
import React.Basic (JSX, element)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component, useEffect)
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
import React.Icons (icon)
import React.Icons.Fa (faGithub, faTwitter)
import React.Icons.Gi (giPencilBrush)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  doc <- document =<< window
  root <- getElementById "root" $ toNonElementParentNode doc
  case root of
    Nothing -> throw "Could not find container element"
    Just container -> do
      app <- mkApp
      reactRoot <- createRoot container
      renderRoot reactRoot (app {})

mkApp :: Component {}
mkApp = component "App" \_ -> React.do
  functions <- useAff unit loadFunctions
  useEffect functions $ do
    log $ show haskellBaseUrl
    log $ show functions
    pure mempty
  pure $ R.div
    { className: "flex flex-col h-screen justify-between"
    , children:
        [ nav
        , startPage
        , appFooter
        ]
    }

nav :: JSX
nav = element navbar
  { className: "shadow-md bg-neutral text-neutral-content"
  , children:
      [ element navbarStart
          { className: "px-2 mx-2"
          , children:
              [ R.span
                  { className: "text-lg font-bold"
                  , children: [ R.text "type-signature.com" ]
                  }
              ]
          }
      ]
  }

startPage :: JSX
startPage = element hero
  { className: "h-80 bg-base-400"
  , children:
      [ element heroContent
          { className: "text-center"
          , children:
              [ R.div
                  { className: "max-w-md flex flex-col items-center"
                  , children:
                      [ icon giPencilBrush { size: "120px", className: "m-4" }
                      , R.h1
                          { className: "text-5xl font-bold"
                          , children: [ R.text "type-signature" ]
                          }
                      , R.p
                          { className: "py-6"
                          , children:
                              [ R.text "Who Wants to Be a Millionaire - but with types" ]
                          }
                      , element button
                          { color: "default"
                          , onClick: handler_ $ pure unit
                          , children: [ R.text "Start" ]
                          }
                      ]
                  }
              ]
          }
      ]
  }

appFooter :: JSX
appFooter = element footer
  { className: "footer footer-center p-10 bg-base-200 text-base-content"
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
