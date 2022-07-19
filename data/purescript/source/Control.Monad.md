## Module Control.Monad

#### `Monad`

``` purescript
class (Applicative m, Bind m) <= Monad m 
```

The `Monad` type class combines the operations of the `Bind` and
`Applicative` type classes. Therefore, `Monad` instances represent type
constructors which support sequential composition, and also lifting of
functions of arbitrary arity.

Instances must satisfy the following laws in addition to the
`Applicative` and `Bind` laws:

- Left Identity: `pure x >>= f = f x`
- Right Identity: `x >>= pure = x`

##### Instances
``` purescript
Monad (Function r)
Monad Array
Monad Proxy
```

#### `liftM1`

``` purescript
liftM1 :: forall m a b. Monad m => (a -> b) -> m a -> m b
```

`liftM1` provides a default implementation of `(<$>)` for any
[`Monad`](#monad), without using `(<$>)` as provided by the
[`Functor`](#functor)-[`Monad`](#monad) superclass relationship.

`liftM1` can therefore be used to write [`Functor`](#functor) instances
as follows:

```purescript
instance functorF :: Functor F where
  map = liftM1
```

#### `whenM`

``` purescript
whenM :: forall m. Monad m => m Boolean -> m Unit -> m Unit
```

Perform a monadic action when a condition is true, where the conditional
value is also in a monadic context.

#### `unlessM`

``` purescript
unlessM :: forall m. Monad m => m Boolean -> m Unit -> m Unit
```

Perform a monadic action unless a condition is true, where the conditional
value is also in a monadic context.

#### `ap`

``` purescript
ap :: forall m a b. Monad m => m (a -> b) -> m a -> m b
```

`ap` provides a default implementation of `(<*>)` for any `Monad`, without
using `(<*>)` as provided by the `Apply`-`Monad` superclass relationship.

`ap` can therefore be used to write `Apply` instances as follows:

```purescript
instance applyF :: Apply F where
  apply = ap
```


### Re-exported from Control.Applicative:

#### `Applicative`

``` purescript
class (Apply f) <= Applicative f  where
  pure :: forall a. a -> f a
```

The `Applicative` type class extends the [`Apply`](#apply) type class
with a `pure` function, which can be used to create values of type `f a`
from values of type `a`.

Where [`Apply`](#apply) provides the ability to lift functions of two or
more arguments to functions whose arguments are wrapped using `f`, and
[`Functor`](#functor) provides the ability to lift functions of one
argument, `pure` can be seen as the function which lifts functions of
_zero_ arguments. That is, `Applicative` functors support a lifting
operation for any number of function arguments.

Instances must satisfy the following laws in addition to the `Apply`
laws:

- Identity: `(pure identity) <*> v = v`
- Composition: `pure (<<<) <*> f <*> g <*> h = f <*> (g <*> h)`
- Homomorphism: `(pure f) <*> (pure x) = pure (f x)`
- Interchange: `u <*> (pure y) = (pure (_ $ y)) <*> u`

##### Instances
``` purescript
Applicative (Function r)
Applicative Array
Applicative Proxy
```

#### `when`

``` purescript
when :: forall m. Applicative m => Boolean -> m Unit -> m Unit
```

Perform an applicative action when a condition is true.

#### `unless`

``` purescript
unless :: forall m. Applicative m => Boolean -> m Unit -> m Unit
```

Perform an applicative action unless a condition is true.

#### `liftA1`

``` purescript
liftA1 :: forall f a b. Applicative f => (a -> b) -> f a -> f b
```

`liftA1` provides a default implementation of `(<$>)` for any
[`Applicative`](#applicative) functor, without using `(<$>)` as provided
by the [`Functor`](#functor)-[`Applicative`](#applicative) superclass
relationship.

`liftA1` can therefore be used to write [`Functor`](#functor) instances
as follows:

```purescript
instance functorF :: Functor F where
  map = liftA1
```

### Re-exported from Control.Apply:

#### `Apply`

``` purescript
class (Functor f) <= Apply f  where
  apply :: forall a b. f (a -> b) -> f a -> f b
```

The `Apply` class provides the `(<*>)` which is used to apply a function
to an argument under a type constructor.

`Apply` can be used to lift functions of two or more arguments to work on
values wrapped with the type constructor `f`. It might also be understood
in terms of the `lift2` function:

```purescript
lift2 :: forall f a b c. Apply f => (a -> b -> c) -> f a -> f b -> f c
lift2 f a b = f <$> a <*> b
```

`(<*>)` is recovered from `lift2` as `lift2 ($)`. That is, `(<*>)` lifts
the function application operator `($)` to arguments wrapped with the
type constructor `f`.

Put differently...
```
foo =
  functionTakingNArguments <$> computationProducingArg1
                           <*> computationProducingArg2
                           <*> ...
                           <*> computationProducingArgN
```

Instances must satisfy the following law in addition to the `Functor`
laws:

- Associative composition: `(<<<) <$> f <*> g <*> h = f <*> (g <*> h)`

Formally, `Apply` represents a strong lax semi-monoidal endofunctor.

##### Instances
``` purescript
Apply (Function r)
Apply Array
Apply Proxy
```

#### `(<*>)`

``` purescript
infixl 4 apply as <*>
```

#### `(<*)`

``` purescript
infixl 4 applyFirst as <*
```

#### `(*>)`

``` purescript
infixl 4 applySecond as *>
```

### Re-exported from Control.Bind:

#### `Bind`

``` purescript
class (Apply m) <= Bind m  where
  bind :: forall a b. m a -> (a -> m b) -> m b
```

The `Bind` type class extends the [`Apply`](#apply) type class with a
"bind" operation `(>>=)` which composes computations in sequence, using
the return value of one computation to determine the next computation.

The `>>=` operator can also be expressed using `do` notation, as follows:

```purescript
x >>= f = do y <- x
             f y
```

where the function argument of `f` is given the name `y`.

Instances must satisfy the following laws in addition to the `Apply`
laws:

- Associativity: `(x >>= f) >>= g = x >>= (\k -> f k >>= g)`
- Apply Superclass: `apply f x = f >>= \f’ -> map f’ x`

Associativity tells us that we can regroup operations which use `do`
notation so that we can unambiguously write, for example:

```purescript
do x <- m1
   y <- m2 x
   m3 x y
```

##### Instances
``` purescript
Bind (Function r)
Bind Array
Bind Proxy
```

#### `join`

``` purescript
join :: forall a m. Bind m => m (m a) -> m a
```

Collapse two applications of a monadic type constructor into one.

#### `ifM`

``` purescript
ifM :: forall a m. Bind m => m Boolean -> m a -> m a -> m a
```

Execute a monadic action if a condition holds.

For example:

```purescript
main = ifM ((< 0.5) <$> random)
         (trace "Heads")
         (trace "Tails")
```

#### `(>>=)`

``` purescript
infixl 1 bind as >>=
```

#### `(>=>)`

``` purescript
infixr 1 composeKleisli as >=>
```

#### `(=<<)`

``` purescript
infixr 1 bindFlipped as =<<
```

#### `(<=<)`

``` purescript
infixr 1 composeKleisliFlipped as <=<
```

### Re-exported from Data.Functor:

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

#### `(<$>)`

``` purescript
infixl 4 map as <$>
```

#### `(<$)`

``` purescript
infixl 4 voidRight as <$
```

#### `(<#>)`

``` purescript
infixl 1 mapFlipped as <#>
```

#### `($>)`

``` purescript
infixl 4 voidLeft as $>
```

