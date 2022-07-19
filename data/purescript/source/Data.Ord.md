## Module Data.Ord

#### `Ord`

``` purescript
class (Eq a) <= Ord a  where
  compare :: a -> a -> Ordering
```

The `Ord` type class represents types which support comparisons with a
_total order_.

`Ord` instances should satisfy the laws of total orderings:

- Reflexivity: `a <= a`
- Antisymmetry: if `a <= b` and `b <= a` then `a = b`
- Transitivity: if `a <= b` and `b <= c` then `a <= c`

**Note:** The `Number` type is not an entirely law abiding member of this
class due to the presence of `NaN`, since `NaN <= NaN` evaluates to `false`

##### Instances
``` purescript
Ord Boolean
Ord Int
Ord Number
Ord String
Ord Char
Ord Unit
Ord Void
Ord (Proxy a)
(Ord a) => Ord (Array a)
Ord Ordering
(RowToList row list, OrdRecord list row) => Ord (Record row)
```

#### `Ord1`

``` purescript
class (Eq1 f) <= Ord1 f  where
  compare1 :: forall a. Ord a => f a -> f a -> Ordering
```

The `Ord1` type class represents totally ordered type constructors.

##### Instances
``` purescript
Ord1 Array
```

#### `lessThan`

``` purescript
lessThan :: forall a. Ord a => a -> a -> Boolean
```

Test whether one value is _strictly less than_ another.

#### `(<)`

``` purescript
infixl 4 lessThan as <
```

#### `lessThanOrEq`

``` purescript
lessThanOrEq :: forall a. Ord a => a -> a -> Boolean
```

Test whether one value is _non-strictly less than_ another.

#### `(<=)`

``` purescript
infixl 4 lessThanOrEq as <=
```

#### `greaterThan`

``` purescript
greaterThan :: forall a. Ord a => a -> a -> Boolean
```

Test whether one value is _strictly greater than_ another.

#### `(>)`

``` purescript
infixl 4 greaterThan as >
```

#### `greaterThanOrEq`

``` purescript
greaterThanOrEq :: forall a. Ord a => a -> a -> Boolean
```

Test whether one value is _non-strictly greater than_ another.

#### `(>=)`

``` purescript
infixl 4 greaterThanOrEq as >=
```

#### `comparing`

``` purescript
comparing :: forall a b. Ord b => (a -> b) -> (a -> a -> Ordering)
```

Compares two values by mapping them to a type with an `Ord` instance.

#### `min`

``` purescript
min :: forall a. Ord a => a -> a -> a
```

Take the minimum of two values. If they are considered equal, the first
argument is chosen.

#### `max`

``` purescript
max :: forall a. Ord a => a -> a -> a
```

Take the maximum of two values. If they are considered equal, the first
argument is chosen.

#### `clamp`

``` purescript
clamp :: forall a. Ord a => a -> a -> a -> a
```

Clamp a value between a minimum and a maximum. For example:

``` purescript
let f = clamp 0 10
f (-5) == 0
f 5    == 5
f 15   == 10
```

#### `between`

``` purescript
between :: forall a. Ord a => a -> a -> a -> Boolean
```

Test whether a value is between a minimum and a maximum (inclusive).
For example:

``` purescript
let f = between 0 10
f 0    == true
f (-5) == false
f 5    == true
f 10   == true
f 15   == false
```

#### `abs`

``` purescript
abs :: forall a. Ord a => Ring a => a -> a
```

The absolute value function. `abs x` is defined as `if x >= zero then x
else negate x`.

#### `signum`

``` purescript
signum :: forall a. Ord a => Ring a => a -> a
```

The sign function; returns `one` if the argument is positive,
`negate one` if the argument is negative, or `zero` if the argument is `zero`.
For floating point numbers with signed zeroes, when called with a zero,
this function returns the argument in order to preserve the sign.
For any `x`, we should have `signum x * abs x == x`.

#### `OrdRecord`

``` purescript
class (EqRecord rowlist row) <= OrdRecord rowlist row  where
  compareRecord :: Proxy rowlist -> Record row -> Record row -> Ordering
```

##### Instances
``` purescript
OrdRecord Nil row
(OrdRecord rowlistTail row, Cons key focus rowTail row, IsSymbol key, Ord focus) => OrdRecord (Cons key focus rowlistTail) row
```


### Re-exported from Data.Ordering:

#### `Ordering`

``` purescript
data Ordering
  = LT
  | GT
  | EQ
```

The `Ordering` data type represents the three possible outcomes of
comparing two values:

`LT` - The first value is _less than_ the second.
`GT` - The first value is _greater than_ the second.
`EQ` - The first value is _equal to_ the second.

##### Instances
``` purescript
Eq Ordering
Semigroup Ordering
Show Ordering
```

