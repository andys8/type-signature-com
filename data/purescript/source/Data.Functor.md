## Module Data.Functor

#### `Functor`

``` purescript
class Functor f  where
  map :: forall a b. (a -> b) -> f a -> f b
```

A `Functor` is a type constructor which supports a mapping operation
`map`.

`map` can be used to turn functions `a -> b` into functions
`f a -> f b` whose argument and return types use the type constructor `f`
to represent some computational context.

Instances must satisfy the following laws:

- Identity: `map identity = identity`
- Composition: `map (f <<< g) = map f <<< map g`

##### Instances
``` purescript
Functor (Function r)
Functor Array
Functor Proxy
```

#### `(<$>)`

``` purescript
infixl 4 map as <$>
```

#### `mapFlipped`

``` purescript
mapFlipped :: forall f a b. Functor f => f a -> (a -> b) -> f b
```

`mapFlipped` is `map` with its arguments reversed. For example:

```purescript
[1, 2, 3] <#> \n -> n * n
```

#### `(<#>)`

``` purescript
infixl 1 mapFlipped as <#>
```

#### `void`

``` purescript
void :: forall f a. Functor f => f a -> f Unit
```

The `void` function is used to ignore the type wrapped by a
[`Functor`](#functor), replacing it with `Unit` and keeping only the type
information provided by the type constructor itself.

`void` is often useful when using `do` notation to change the return type
of a monadic computation:

```purescript
main = forE 1 10 \n -> void do
  print n
  print (n * n)
```

#### `voidRight`

``` purescript
voidRight :: forall f a b. Functor f => a -> f b -> f a
```

Ignore the return value of a computation, using the specified return value
instead.

#### `(<$)`

``` purescript
infixl 4 voidRight as <$
```

#### `voidLeft`

``` purescript
voidLeft :: forall f a b. Functor f => f a -> b -> f b
```

A version of `voidRight` with its arguments flipped.

#### `($>)`

``` purescript
infixl 4 voidLeft as $>
```

#### `flap`

``` purescript
flap :: forall f a b. Functor f => f (a -> b) -> a -> f b
```

Apply a value in a computational context to a value in no context.

Generalizes `flip`.

```purescript
longEnough :: String -> Bool
hasSymbol :: String -> Bool
hasDigit :: String -> Bool
password :: String

validate :: String -> Array Bool
validate = flap [longEnough, hasSymbol, hasDigit]
```

```purescript
flap (-) 3 4 == 1
threeve <$> Just 1 <@> 'a' <*> Just true == Just (threeve 1 'a' true)
```

#### `(<@>)`

``` purescript
infixl 4 flap as <@>
```


