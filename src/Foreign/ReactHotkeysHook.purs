module Foreign.ReactHotkeysHook (useHotkeys, UseHotkeys) where

import Prelude

import Effect (Effect)
import Effect.Aff.Compat (runEffectFn2)
import Effect.Uncurried (EffectFn2)
import React.Basic.Hooks (Hook, unsafeHook)

foreign import _useHotkeys :: EffectFn2 String (Effect Unit) Unit
foreign import data UseHotkeys :: Type -> Type -> Type

type Key = String

useHotkeys :: forall a. Key -> Effect Unit -> Hook (UseHotkeys a) Unit
useHotkeys key handler = unsafeHook $ runEffectFn2 _useHotkeys key handler
