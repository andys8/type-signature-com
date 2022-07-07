module Main where

import Prelude

import Data.Functions (loadFunctions)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import Effect.Exception (throw)
import Foreign.Daisyui (button, footer, footerTitle, hero, heroContent, navbar, navbarStart)
import Foreign.Object as O
import React.Basic (JSX, element)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component, useEffect)
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
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
    log $ show functions
    pure mempty
  pure $ R.div
    { _data: O.fromHomogeneous { theme: "dracula" }
    , className: "flex flex-col h-screen justify-between"
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
                  { className: "max-w-md"
                  , children:
                      [ R.h1
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
  { center: false
  , className: "p-10 bg-neutral text-neutral-content"
  , children:
      [ R.div_
          [ element footerTitle { children: [ R.text "About" ] }
          , R.a
              { className: "link link-hover"
              , href: "https://github.com/andys8/type-signature-com"
              , children: [ R.text "Github" ]
              }
          , R.a
              { className: "link link-hover"
              , href: "https://twitter.com/_andys8"
              , children: [ R.text "Twitter" ]
              }
          ]
      , R.div_
          [ element footerTitle { children: [ R.text "Learn Haskell" ] }
          , R.a
              { className: "link link-hover"
              , href: "https://wiki.haskell.org/Type_signature"
              , children: [ R.text "Haskell Wiki" ]
              }
          , R.a
              { className: "link link-hover"
              , href: "https://hoogle.haskell.org"
              , children: [ R.text "Hoogle" ]
              }
          ]
      ]
  }
