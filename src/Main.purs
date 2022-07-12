module Main where

import Prelude

import Components.AppFooter (appFooter)
import Components.AppNavbar (appNavbar)
import Components.PageStart (pageStart)
import Data.Functions (haskellBaseUrl, loadFunctions)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class.Console (log)
import Effect.Exception (throw)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.Hooks (Component, component, useEffect)
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (mkAffReducer, useAff, useAffReducer)
import State (initState, reducer)
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
mkApp = do
  r <- mkAffReducer reducer
  component "App" \_ -> React.do
    functions <- useAff unit loadFunctions
    useEffect functions $ do
      log $ show haskellBaseUrl
      log $ show functions
      pure mempty
    state /\ dispatch <- useAffReducer initState r
    pure $ R.div
      { className: "flex flex-col h-screen justify-between"
      , children:
          [ appNavbar
          , pageStart dispatch
          , appFooter
          ]
      }

