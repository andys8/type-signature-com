module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff.Compat (EffectFn1, runEffectFn1)
import Effect.Exception (throw)
import React.Basic (JSX)
import React.Basic.DOM as R
import React.Basic.Hooks (Component, component)
import Web.DOM.Element (Element)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

foreign import createRoot :: EffectFn1 Element { render :: EffectFn1 JSX Unit }

main :: Effect Unit
main = do
  doc <- document =<< window
  root <- getElementById "root" $ toNonElementParentNode doc
  case root of
    Nothing -> throw "Could not find container element"
    Just container -> do
      app <- mkApp
      { render } <- runEffectFn1 createRoot container
      runEffectFn1 render (app {})

mkApp :: Component {}
mkApp = do
  component "App" \_ -> React.do
    pure $ R.text "Hi there"
