## Module Data.Maybe

#### `Maybe`

``` purescript
data Maybe a
  = Nothing
  | Just a
```

The `Maybe` type is used to represent optional values and can be seen as
something like a type-safe `null`, where `Nothing` is `null` and `Just x`
is the non-null value `x`.

##### Instances
``` purescript
Functor Maybe
Apply Maybe
Applicative Maybe
Alt Maybe
Plus Maybe
Alternative Maybe
Bind Maybe
Monad Maybe
Extend Maybe
Invariant Maybe
(Semigroup a) => Semigroup (Maybe a)
(Semigroup a) => Monoid (Maybe a)
(Semiring a) => Semiring (Maybe a)
(Eq a) => Eq (Maybe a)
Eq1 Maybe
(Ord a) => Ord (Maybe a)
Ord1 Maybe
(Bounded a) => Bounded (Maybe a)
(Show a) => Show (Maybe a)
Generic (Maybe a) _
```

#### `maybe`

``` purescript
maybe :: forall a b. b -> (a -> b) -> Maybe a -> b
```

Takes a default value, a function, and a `Maybe` value. If the `Maybe`
value is `Nothing` the default value is returned, otherwise the function
is applied to the value inside the `Just` and the result is returned.

``` purescript
maybe x f Nothing == x
maybe x f (Just y) == f y
```

#### `maybe'`

``` purescript
maybe' :: forall a b. (Unit -> b) -> (a -> b) -> Maybe a -> b
```

Similar to `maybe` but for use in cases where the default value may be
expensive to compute. As PureScript is not lazy, the standard `maybe` has
to evaluate the default value before returning the result, whereas here
the value is only computed when the `Maybe` is known to be `Nothing`.

``` purescript
maybe' (\_ -> x) f Nothing == x
maybe' (\_ -> x) f (Just y) == f y
```

#### `fromMaybe`

``` purescript
fromMaybe :: forall a. a -> Maybe a -> a
```

Takes a default value, and a `Maybe` value. If the `Maybe` value is
`Nothing` the default value is returned, otherwise the value inside the
`Just` is returned.

``` purescript
fromMaybe x Nothing == x
fromMaybe x (Just y) == y
```

#### `fromMaybe'`

``` purescript
fromMaybe' :: forall a. (Unit -> a) -> Maybe a -> a
```

Similar to `fromMaybe` but for use in cases where the default value may be
expensive to compute. As PureScript is not lazy, the standard `fromMaybe`
has to evaluate the default value before returning the result, whereas here
the value is only computed when the `Maybe` is known to be `Nothing`.

``` purescript
fromMaybe' (\_ -> x) Nothing == x
fromMaybe' (\_ -> x) (Just y) == y
```

#### `isJust`

``` purescript
isJust :: forall a. Maybe a -> Boolean
```

Returns `true` when the `Maybe` value was constructed with `Just`.

#### `isNothing`

``` purescript
isNothing :: forall a. Maybe a -> Boolean
```

Returns `true` when the `Maybe` value is `Nothing`.

#### `fromJust`

``` purescript
fromJust :: forall a. Partial => Maybe a -> a
```

A partial function that extracts the value from the `Just` data
constructor. Passing `Nothing` to `fromJust` will throw an error at
runtime.

#### `optional`

``` purescript
optional :: forall f a. Alt f => Applicative f => f a -> f (Maybe a)
```

One or none.

```purescript
optional empty = pure Nothing
```

The behaviour of `optional (pure x)` depends on whether the `Alt` instance
satisfy the left catch law (`pure a <|> b = pure a`).

`Either e` does:

```purescript
optional (Right x) = Right (Just x)
```

But `Array` does not:

```purescript
optional [x] = [Just x, Nothing]
```


