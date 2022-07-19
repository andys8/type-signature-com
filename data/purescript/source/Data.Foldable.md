## Module Data.Foldable

#### `Foldable`

``` purescript
class Foldable f  where
  foldr :: forall a b. (a -> b -> b) -> b -> f a -> b
  foldl :: forall a b. (b -> a -> b) -> b -> f a -> b
  foldMap :: forall a m. Monoid m => (a -> m) -> f a -> m
```

`Foldable` represents data structures which can be _folded_.

- `foldr` folds a structure from the right
- `foldl` folds a structure from the left
- `foldMap` folds a structure by accumulating values in a `Monoid`

Default implementations are provided by the following functions:

- `foldrDefault`
- `foldlDefault`
- `foldMapDefaultR`
- `foldMapDefaultL`

Note: some combinations of the default implementations are unsafe to
use together - causing a non-terminating mutually recursive cycle.
These combinations are documented per function.

##### Instances
``` purescript
Foldable Array
Foldable Maybe
Foldable First
Foldable Last
Foldable Additive
Foldable Dual
Foldable Disj
Foldable Conj
Foldable Multiplicative
Foldable (Either a)
Foldable (Tuple a)
Foldable Identity
Foldable (Const a)
(Foldable f, Foldable g) => Foldable (Product f g)
(Foldable f, Foldable g) => Foldable (Coproduct f g)
(Foldable f, Foldable g) => Foldable (Compose f g)
(Foldable f) => Foldable (App f)
```

#### `foldrDefault`

``` purescript
foldrDefault :: forall f a b. Foldable f => (a -> b -> b) -> b -> f a -> b
```

A default implementation of `foldr` using `foldMap`.

Note: when defining a `Foldable` instance, this function is unsafe to use
in combination with `foldMapDefaultR`.

#### `foldlDefault`

``` purescript
foldlDefault :: forall f a b. Foldable f => (b -> a -> b) -> b -> f a -> b
```

A default implementation of `foldl` using `foldMap`.

Note: when defining a `Foldable` instance, this function is unsafe to use
in combination with `foldMapDefaultL`.

#### `foldMapDefaultL`

``` purescript
foldMapDefaultL :: forall f a m. Foldable f => Monoid m => (a -> m) -> f a -> m
```

A default implementation of `foldMap` using `foldl`.

Note: when defining a `Foldable` instance, this function is unsafe to use
in combination with `foldlDefault`.

#### `foldMapDefaultR`

``` purescript
foldMapDefaultR :: forall f a m. Foldable f => Monoid m => (a -> m) -> f a -> m
```

A default implementation of `foldMap` using `foldr`.

Note: when defining a `Foldable` instance, this function is unsafe to use
in combination with `foldrDefault`.

#### `fold`

``` purescript
fold :: forall f m. Foldable f => Monoid m => f m -> m
```

Fold a data structure, accumulating values in some `Monoid`.

#### `foldM`

``` purescript
foldM :: forall f m a b. Foldable f => Monad m => (b -> a -> m b) -> b -> f a -> m b
```

Similar to 'foldl', but the result is encapsulated in a monad.

Note: this function is not generally stack-safe, e.g., for monads which
build up thunks a la `Eff`.

#### `traverse_`

``` purescript
traverse_ :: forall a b f m. Applicative m => Foldable f => (a -> m b) -> f a -> m Unit
```

Traverse a data structure, performing some effects encoded by an
`Applicative` functor at each value, ignoring the final result.

For example:

```purescript
traverse_ print [1, 2, 3]
```

#### `for_`

``` purescript
for_ :: forall a b f m. Applicative m => Foldable f => f a -> (a -> m b) -> m Unit
```

A version of `traverse_` with its arguments flipped.

This can be useful when running an action written using do notation
for every element in a data structure:

For example:

```purescript
for_ [1, 2, 3] \n -> do
  print n
  trace "squared is"
  print (n * n)
```

#### `sequence_`

``` purescript
sequence_ :: forall a f m. Applicative m => Foldable f => f (m a) -> m Unit
```

Perform all of the effects in some data structure in the order
given by the `Foldable` instance, ignoring the final result.

For example:

```purescript
sequence_ [ trace "Hello, ", trace " world!" ]
```

#### `oneOf`

``` purescript
oneOf :: forall f g a. Foldable f => Plus g => f (g a) -> g a
```

Combines a collection of elements using the `Alt` operation.

#### `oneOfMap`

``` purescript
oneOfMap :: forall f g a b. Foldable f => Plus g => (a -> g b) -> f a -> g b
```

Folds a structure into some `Plus`.

#### `intercalate`

``` purescript
intercalate :: forall f m. Foldable f => Monoid m => m -> f m -> m
```

Fold a data structure, accumulating values in some `Monoid`,
combining adjacent elements using the specified separator.

For example:

```purescript
> intercalate ", " ["Lorem", "ipsum", "dolor"]
= "Lorem, ipsum, dolor"

> intercalate "*" ["a", "b", "c"]
= "a*b*c"

> intercalate [1] [[2, 3], [4, 5], [6, 7]]
= [2, 3, 1, 4, 5, 1, 6, 7]
```

#### `surroundMap`

``` purescript
surroundMap :: forall f a m. Foldable f => Semigroup m => m -> (a -> m) -> f a -> m
```

`foldMap` but with each element surrounded by some fixed value.

For example:

```purescript
> surroundMap "*" show []
= "*"

> surroundMap "*" show [1]
= "*1*"

> surroundMap "*" show [1, 2]
= "*1*2*"

> surroundMap "*" show [1, 2, 3]
= "*1*2*3*"
```

#### `surround`

``` purescript
surround :: forall f m. Foldable f => Semigroup m => m -> f m -> m
```

`fold` but with each element surrounded by some fixed value.

For example:

```purescript
> surround "*" []
= "*"

> surround "*" ["1"]
= "*1*"

> surround "*" ["1", "2"]
= "*1*2*"

> surround "*" ["1", "2", "3"]
= "*1*2*3*"
```

#### `and`

``` purescript
and :: forall a f. Foldable f => HeytingAlgebra a => f a -> a
```

The conjunction of all the values in a data structure. When specialized
to `Boolean`, this function will test whether all of the values in a data
structure are `true`.

#### `or`

``` purescript
or :: forall a f. Foldable f => HeytingAlgebra a => f a -> a
```

The disjunction of all the values in a data structure. When specialized
to `Boolean`, this function will test whether any of the values in a data
structure is `true`.

#### `all`

``` purescript
all :: forall a b f. Foldable f => HeytingAlgebra b => (a -> b) -> f a -> b
```

`all f` is the same as `and <<< map f`; map a function over the structure,
and then get the conjunction of the results.

#### `any`

``` purescript
any :: forall a b f. Foldable f => HeytingAlgebra b => (a -> b) -> f a -> b
```

`any f` is the same as `or <<< map f`; map a function over the structure,
and then get the disjunction of the results.

#### `sum`

``` purescript
sum :: forall a f. Foldable f => Semiring a => f a -> a
```

Find the sum of the numeric values in a data structure.

#### `product`

``` purescript
product :: forall a f. Foldable f => Semiring a => f a -> a
```

Find the product of the numeric values in a data structure.

#### `elem`

``` purescript
elem :: forall a f. Foldable f => Eq a => a -> f a -> Boolean
```

Test whether a value is an element of a data structure.

#### `notElem`

``` purescript
notElem :: forall a f. Foldable f => Eq a => a -> f a -> Boolean
```

Test whether a value is not an element of a data structure.

#### `indexl`

``` purescript
indexl :: forall a f. Foldable f => Int -> f a -> Maybe a
```

Try to get nth element from the left in a data structure

#### `indexr`

``` purescript
indexr :: forall a f. Foldable f => Int -> f a -> Maybe a
```

Try to get nth element from the right in a data structure

#### `find`

``` purescript
find :: forall a f. Foldable f => (a -> Boolean) -> f a -> Maybe a
```

Try to find an element in a data structure which satisfies a predicate.

#### `findMap`

``` purescript
findMap :: forall a b f. Foldable f => (a -> Maybe b) -> f a -> Maybe b
```

Try to find an element in a data structure which satisfies a predicate mapping.

#### `maximum`

``` purescript
maximum :: forall a f. Ord a => Foldable f => f a -> Maybe a
```

Find the largest element of a structure, according to its `Ord` instance.

#### `maximumBy`

``` purescript
maximumBy :: forall a f. Foldable f => (a -> a -> Ordering) -> f a -> Maybe a
```

Find the largest element of a structure, according to a given comparison
function. The comparison function should represent a total ordering (see
the `Ord` type class laws); if it does not, the behaviour is undefined.

#### `minimum`

``` purescript
minimum :: forall a f. Ord a => Foldable f => f a -> Maybe a
```

Find the smallest element of a structure, according to its `Ord` instance.

#### `minimumBy`

``` purescript
minimumBy :: forall a f. Foldable f => (a -> a -> Ordering) -> f a -> Maybe a
```

Find the smallest element of a structure, according to a given comparison
function. The comparison function should represent a total ordering (see
the `Ord` type class laws); if it does not, the behaviour is undefined.

#### `null`

``` purescript
null :: forall a f. Foldable f => f a -> Boolean
```

Test whether the structure is empty.
Optimized for structures that are similar to cons-lists, because there
is no general way to do better.

#### `length`

``` purescript
length :: forall a b f. Foldable f => Semiring b => f a -> b
```

Returns the size/length of a finite structure.
Optimized for structures that are similar to cons-lists, because there
is no general way to do better.

#### `lookup`

``` purescript
lookup :: forall a b f. Foldable f => Eq a => a -> f (Tuple a b) -> Maybe b
```

Lookup a value in a data structure of `Tuple`s, generalizing association lists.


