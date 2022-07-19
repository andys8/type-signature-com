## Module Effect

This module provides the `Effect` type, which is used to represent
_native_ effects. The `Effect` type provides a typed API for effectful
computations, while at the same time generating efficient JavaScript.

#### `Effect`

``` purescript
data Effect t0
```

A native effect. The type parameter denotes the return type of running the
effect, that is, an `Effect Int` is a possibly-effectful computation which
eventually produces a value of the type `Int` when it finishes.

##### Instances
``` purescript
Functor Effect
Apply Effect
Applicative Effect
Bind Effect
Monad Effect
(Semigroup a) => Semigroup (Effect a)
(Monoid a) => Monoid (Effect a)
```

#### `untilE`

``` purescript
untilE :: Effect Boolean -> Effect Unit
```

Loop until a condition becomes `true`.

`untilE b` is an effectful computation which repeatedly runs the effectful
computation `b`, until its return value is `true`.

#### `whileE`

``` purescript
whileE :: forall a. Effect Boolean -> Effect a -> Effect Unit
```

Loop while a condition is `true`.

`whileE b m` is effectful computation which runs the effectful computation
`b`. If its result is `true`, it runs the effectful computation `m` and
loops. If not, the computation ends.

#### `forE`

``` purescript
forE :: Int -> Int -> (Int -> Effect Unit) -> Effect Unit
```

Loop over a consecutive collection of numbers.

`forE lo hi f` runs the computation returned by the function `f` for each
of the inputs between `lo` (inclusive) and `hi` (exclusive).

#### `foreachE`

``` purescript
foreachE :: forall a. Array a -> (a -> Effect Unit) -> Effect Unit
```

Loop over an array of values.

`foreachE xs f` runs the computation returned by the function `f` for each
of the inputs `xs`.


