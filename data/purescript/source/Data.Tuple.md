## Module Data.Tuple

A data type and functions for working with ordered pairs.

#### `Tuple`

``` purescript
data Tuple a b
  = Tuple a b
```

A simple product type for wrapping a pair of component values.

##### Instances
``` purescript
(Show a, Show b) => Show (Tuple a b)
(Eq a, Eq b) => Eq (Tuple a b)
(Eq a) => Eq1 (Tuple a)
(Ord a, Ord b) => Ord (Tuple a b)
(Ord a) => Ord1 (Tuple a)
(Bounded a, Bounded b) => Bounded (Tuple a b)
Semigroupoid Tuple
(Semigroup a, Semigroup b) => Semigroup (Tuple a b)
(Monoid a, Monoid b) => Monoid (Tuple a b)
(Semiring a, Semiring b) => Semiring (Tuple a b)
(Ring a, Ring b) => Ring (Tuple a b)
(CommutativeRing a, CommutativeRing b) => CommutativeRing (Tuple a b)
(HeytingAlgebra a, HeytingAlgebra b) => HeytingAlgebra (Tuple a b)
(BooleanAlgebra a, BooleanAlgebra b) => BooleanAlgebra (Tuple a b)
Functor (Tuple a)
Generic (Tuple a b) _
Invariant (Tuple a)
(Semigroup a) => Apply (Tuple a)
(Monoid a) => Applicative (Tuple a)
(Semigroup a) => Bind (Tuple a)
(Monoid a) => Monad (Tuple a)
Extend (Tuple a)
Comonad (Tuple a)
(Lazy a, Lazy b) => Lazy (Tuple a b)
```

#### `fst`

``` purescript
fst :: forall a b. Tuple a b -> a
```

Returns the first component of a tuple.

#### `snd`

``` purescript
snd :: forall a b. Tuple a b -> b
```

Returns the second component of a tuple.

#### `curry`

``` purescript
curry :: forall a b c. (Tuple a b -> c) -> a -> b -> c
```

Turn a function that expects a tuple into a function of two arguments.

#### `uncurry`

``` purescript
uncurry :: forall a b c. (a -> b -> c) -> Tuple a b -> c
```

Turn a function of two arguments into a function that expects a tuple.

#### `swap`

``` purescript
swap :: forall a b. Tuple a b -> Tuple b a
```

Exchange the first and second components of a tuple.


