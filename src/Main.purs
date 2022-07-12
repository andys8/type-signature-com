module Main where

import Prelude

import Components.AppContent (appContent)
import Components.AppFooter (appFooter)
import Components.AppNavbar (appNavbar)
import Components.PageGameInProgress (pageGameInProgress)
import Components.PageStart (pageStart)
import Data.Array as A
import Data.Functions (loadFunctions)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component)
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (mkAffReducer, useAff, useAffReducer)
import State (Action(..), GameState(..), initState, reducer)
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
    response <- useAff unit loadFunctions
    let functions = fromMaybe [] response
    state /\ dispatch <- useAffReducer (initState functions) r
    let
      page = case state.gameState of
        GameBeforeStart ->
          pageStart
            { isLoading: A.null functions
            , onStartClick: handler_ $ dispatch ActionGameStart
            }
        GameInProgress inProgressState ->
          pageGameInProgress
            { inProgressState
            , onAnswerClick: dispatch <<< ActionAnswer
            }
        GameEnd ->
          R.text "Ended"
    pure $ R.div
      { className: "flex flex-col justify-between absolute inset-0"
      , children:
          [ appNavbar
          , appContent page
          , appFooter
          ]
      }

