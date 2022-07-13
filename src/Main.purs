module Main where

import Prelude

import Components.AppContent (appContent)
import Components.AppFooter (appFooter)
import Components.AppNavbar (appNavbar)
import Components.PageGameInProgress (pageGameInProgress)
import Components.PageStart (pageStart)
import Data.Either (Either(..))
import Data.Haskell (haskellPreludeUrl, loadFunctions)
import Data.Maybe (Maybe(..))
import Data.Set.NonEmpty (NonEmptySet)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Exception (throw)
import Functions (Fun, parseFunctions)
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
  game <- mkGame
  component "App" \_ -> React.do
    response <- useAff unit $ loadFunctions haskellPreludeUrl
    let
      content = case response of
        -- TODO: Loading page
        Nothing -> R.text $ "loading"
        Just r ->
          case parseFunctions =<< r of
            -- TODO: Error
            Left x -> R.text $ "Issue: " <> x
            Right functions -> game { functions }

    pure $ R.div
      { className: "flex flex-col justify-between absolute inset-0"
      , children:
          [ appNavbar
          , appContent content
          , appFooter
          ]
      }

mkGame :: Component { functions :: NonEmptySet Fun }
mkGame = do
  r <- mkAffReducer reducer
  component "App" \{ functions } -> React.do
    state /\ dispatch <- useAffReducer (initState functions) r
    pure case state.gameState of
      GameBeforeStart ->
        pageStart
          { onStartClick: handler_ $ dispatch ActionGameStart
          }
      GameInProgress inProgressState ->
        pageGameInProgress
          { inProgressState
          , onAnswerClick: dispatch <<< ActionAnswer
          }
      GameEnd ->
        R.text "Ended"

