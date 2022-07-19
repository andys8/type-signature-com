## Module Data.Eq

#### `Eq`

``` purescript
class Eq a  where
  eq :: a -> a -> Boolean
```

The `Eq` type class represents types which support decidable equality.

`Eq` instances should satisfy the following laws:

- Reflexivity: `x == x = true`
- Symmetry: `x == y = y == x`
- Transitivity: if `x == y` and `y == z` then `x == z`

**Note:** The `Number` type is not an entirely law abiding member of this
class due to the presence of `NaN`, since `NaN /= NaN`. Additionally,
computing with `Number` can result in a loss of precision, so sometimes
values that should be equivalent are not.

##### Instances
``` purescript
Eq Boolean
Eq Int
Eq Number
Eq Char
Eq String
Eq Unit
Eq Void
(Eq a) => Eq (Array a)
(RowToList row list, EqRecord list row) => Eq (Record row)
Eq (Proxy a)
```

#### `(==)`

``` purescript
infix 4 eq as ==
```

#### `notEq`

``` purescript
notEq :: forall a. Eq a => a -> a -> Boolean
```

`notEq` tests whether one value is _not equal_ to another. Shorthand for
`not (eq x y)`.

#### `(/=)`

``` purescript
infix 4 notEq as /=
```

#### `Eq1`

``` purescript
class Eq1 f  where
  eq1 :: forall a. Eq a => f a -> f a -> Boolean
```

The `Eq1` type class represents type constructors with decidable equality.

##### Instances
``` purescript
Eq1 Array
```

#### `notEq1`

``` purescript
notEq1 :: forall f a. Eq1 f => Eq a => f a -> f a -> Boolean
```

#### `EqRecord`

``` purescript
class EqRecord rowlist row  where
  eqRecord :: Proxy rowlist -> Record row -> Record row -> Boolean
```

A class for records where all fields have `Eq` instances, used to implement
the `Eq` instance for records.

##### Instances
``` purescript
EqRecord Nil row
(EqRecord rowlistTail row, Cons key focus rowTail row, IsSymbol key, Eq focus) => EqRecord (Cons key focus rowlistTail) row
```


