module Main where

import Prelude

import Components.AppFooter (appFooter)
import Components.AppNavbar (appNavbar)
import Components.PageGameEnd (pageGameEnd)
import Components.PageGameInProgress (pageGameInProgress)
import Components.PageStart (pageStart)
import Control.Parallel (parSequence)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Exception (throw)
import Foreign.Daisyui (alert, progress)
import Functions (loadFunctions, parseFunctions)
import FunctionsRaw (urls)
import React.Basic (element)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component)
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (mkAffReducer, useAff, useAffReducer)
import State (Action(..), GameState(..), Functions, initState, reducer)
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
    response <- useAff unit loadAllFunctions
    let
      content = case response of
        Nothing -> element progress { className: "w-56" }
        Just r -> case r of
          Left err -> element alert { status: "error", children: [ R.text err ] }
          Right functions -> game { functions }

      appContent = R.main
        { className: "flex flex-col items-center justify-center flex-1 h-full p-5 text-center"
        , children: [ content ]
        }

    pure $ R.div
      { className: "absolute inset-0 flex flex-col justify-between font-sans"
      , children:
          [ appNavbar
          , appContent
          , appFooter
          ]
      }

mkGame :: Component { functions :: Functions }
mkGame = do
  r <- mkAffReducer reducer
  component "App" \{ functions } -> React.do
    state /\ dispatch <- useAffReducer (initState functions) r
    let { language } = state
    pure case state.gameState of
      GameBeforeStart ->
        pageStart
          { onStartClick: dispatch ActionGameStart
          , onLanguageSet: dispatch <<< ActionLanguageSet
          , language
          }
      GameInProgress inProgressState ->
        pageGameInProgress
          { onAnswerClick: dispatch <<< ActionAnswer
          , inProgressState
          , language
          }
      GameEnd answeredQuestions ->
        pageGameEnd
          { onRestart: handler_ $ dispatch ActionGameStart
          , answeredQuestions
          , language
          }

loadAllFunctions :: Aff (Either String Functions)
loadAllFunctions = do
  functions <- parSequence $ loadFunctions <$>
    [ urls.haskell
    , urls.purescript
    , urls.elm
    ]
  pure $ toAllFunctions =<< traverse ((=<<) parseFunctions) functions
  where
  toAllFunctions [ haskell, purescript, elm ] = Right { haskell, purescript, elm }
  toAllFunctions _ = Left "Can't create AllFunctions"
