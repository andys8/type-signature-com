## Module Prelude

`Prelude` is a module that re-exports many other foundational modules from the `purescript-prelude` library
(e.g. the Monad type class hierarchy, the Monoid type classes, Eq, Ord, etc.).

Typically, this module will be imported in most other libraries and projects as an open import.

```
module MyModule where

import Prelude -- open import

import Data.Maybe (Maybe(..)) -- closed import
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

#### `Discard`

``` purescript
class Discard a  where
  discard :: forall f b. Bind f => f a -> (a -> f b) -> f b
```

A class for types whose values can safely be discarded
in a `do` notation block.

An example is the `Unit` type, since there is only one
possible value which can be returned.

##### Instances
``` purescript
Discard Unit
Discard (Proxy a)
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

### Re-exported from Control.Category:

#### `Category`

``` purescript
class (Semigroupoid a) <= Category a  where
  identity :: forall t. a t t
```

`Category`s consist of objects and composable morphisms between them, and
as such are [`Semigroupoids`](#semigroupoid), but unlike `semigroupoids`
must have an identity element.

Instances must satisfy the following law in addition to the
`Semigroupoid` law:

- Identity: `identity <<< p = p <<< identity = p`

##### Instances
``` purescript
Category Function
```

### Re-exported from Control.Monad:

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

### Re-exported from Control.Semigroupoid:

#### `Semigroupoid`

``` purescript
class Semigroupoid a  where
  compose :: forall b c d. a c d -> a b c -> a b d
```

A `Semigroupoid` is similar to a [`Category`](#category) but does not
require an identity element `identity`, just composable morphisms.

`Semigroupoid`s must satisfy the following law:

- Associativity: `p <<< (q <<< r) = (p <<< q) <<< r`

One example of a `Semigroupoid` is the function type constructor `(->)`,
with `(<<<)` defined as function composition.

##### Instances
``` purescript
Semigroupoid Function
```

#### `(>>>)`

``` purescript
infixr 9 composeFlipped as >>>
```

#### `(<<<)`

``` purescript
infixr 9 compose as <<<
```

### Re-exported from Data.Boolean:

#### `otherwise`

``` purescript
otherwise :: Boolean
```

An alias for `true`, which can be useful in guard clauses:

```purescript
max x y | x >= y    = x
        | otherwise = y
```

### Re-exported from Data.BooleanAlgebra:

#### `BooleanAlgebra`

``` purescript
class (HeytingAlgebra a) <= BooleanAlgebra a 
```

The `BooleanAlgebra` type class represents types that behave like boolean
values.

Instances should satisfy the following laws in addition to the
`HeytingAlgebra` law:

- Excluded middle:
  - `a || not a = tt`

##### Instances
``` purescript
BooleanAlgebra Boolean
BooleanAlgebra Unit
(BooleanAlgebra b) => BooleanAlgebra (a -> b)
(RowToList row list, BooleanAlgebraRecord list row row) => BooleanAlgebra (Record row)
BooleanAlgebra (Proxy a)
```

### Re-exported from Data.Bounded:

#### `Bounded`

``` purescript
class (Ord a) <= Bounded a  where
  top :: a
  bottom :: a
```

The `Bounded` type class represents totally ordered types that have an
upper and lower boundary.

Instances should satisfy the following law in addition to the `Ord` laws:

- Bounded: `bottom <= a <= top`

##### Instances
``` purescript
Bounded Boolean
Bounded Int
Bounded Char
Bounded Ordering
Bounded Unit
Bounded Number
Bounded (Proxy a)
(RowToList row list, BoundedRecord list row row) => Bounded (Record row)
```

### Re-exported from Data.CommutativeRing:

#### `CommutativeRing`

``` purescript
class (Ring a) <= CommutativeRing a 
```

The `CommutativeRing` class is for rings where multiplication is
commutative.

Instances must satisfy the following law in addition to the `Ring`
laws:

- Commutative multiplication: `a * b = b * a`

##### Instances
``` purescript
CommutativeRing Int
CommutativeRing Number
CommutativeRing Unit
(CommutativeRing b) => CommutativeRing (a -> b)
(RowToList row list, CommutativeRingRecord list row row) => CommutativeRing (Record row)
CommutativeRing (Proxy a)
```

### Re-exported from Data.DivisionRing:

#### `DivisionRing`

``` purescript
class (Ring a) <= DivisionRing a  where
  recip :: a -> a
```

The `DivisionRing` class is for non-zero rings in which every non-zero
element has a multiplicative inverse. Division rings are sometimes also
called *skew fields*.

Instances must satisfy the following laws in addition to the `Ring` laws:

- Non-zero ring: `one /= zero`
- Non-zero multiplicative inverse: `recip a * a = a * recip a = one` for
  all non-zero `a`

The result of `recip zero` is left undefined; individual instances may
choose how to handle this case.

If a type has both `DivisionRing` and `CommutativeRing` instances, then
it is a field and should have a `Field` instance.

##### Instances
``` purescript
DivisionRing Number
```

### Re-exported from Data.Eq:

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

#### `notEq`

``` purescript
notEq :: forall a. Eq a => a -> a -> Boolean
```

`notEq` tests whether one value is _not equal_ to another. Shorthand for
`not (eq x y)`.

#### `(==)`

``` purescript
infix 4 eq as ==
```

#### `(/=)`

``` purescript
infix 4 notEq as /=
```

### Re-exported from Data.EuclideanRing:

#### `EuclideanRing`

``` purescript
class (CommutativeRing a) <= EuclideanRing a  where
  degree :: a -> Int
  div :: a -> a -> a
  mod :: a -> a -> a
```

The `EuclideanRing` class is for commutative rings that support division.
The mathematical structure this class is based on is sometimes also called
a *Euclidean domain*.

Instances must satisfy the following laws in addition to the `Ring`
laws:

- Integral domain: `one /= zero`, and if `a` and `b` are both nonzero then
  so is their product `a * b`
- Euclidean function `degree`:
  - Nonnegativity: For all nonzero `a`, `degree a >= 0`
  - Quotient/remainder: For all `a` and `b`, where `b` is nonzero,
    let `q = a / b` and ``r = a `mod` b``; then `a = q*b + r`, and also
    either `r = zero` or `degree r < degree b`
- Submultiplicative euclidean function:
  - For all nonzero `a` and `b`, `degree a <= degree (a * b)`

The behaviour of division by `zero` is unconstrained by these laws,
meaning that individual instances are free to choose how to behave in this
case. Similarly, there are no restrictions on what the result of
`degree zero` is; it doesn't make sense to ask for `degree zero` in the
same way that it doesn't make sense to divide by `zero`, so again,
individual instances may choose how to handle this case.

For any `EuclideanRing` which is also a `Field`, one valid choice
for `degree` is simply `const 1`. In fact, unless there's a specific
reason not to, `Field` types should normally use this definition of
`degree`.

The `EuclideanRing Int` instance is one of the most commonly used
`EuclideanRing` instances and deserves a little more discussion. In
particular, there are a few different sensible law-abiding implementations
to choose from, with slightly different behaviour in the presence of
negative dividends or divisors. The most common definitions are "truncating"
division, where the result of `a / b` is rounded towards 0, and "Knuthian"
or "flooring" division, where the result of `a / b` is rounded towards
negative infinity. A slightly less common, but arguably more useful, option
is "Euclidean" division, which is defined so as to ensure that ``a `mod` b``
is always nonnegative. With Euclidean division, `a / b` rounds towards
negative infinity if the divisor is positive, and towards positive infinity
if the divisor is negative. Note that all three definitions are identical if
we restrict our attention to nonnegative dividends and divisors.

In versions 1.x, 2.x, and 3.x of the Prelude, the `EuclideanRing Int`
instance used truncating division. As of 4.x, the `EuclideanRing Int`
instance uses Euclidean division. Additional functions `quot` and `rem` are
supplied if truncating division is desired.

##### Instances
``` purescript
EuclideanRing Int
EuclideanRing Number
```

#### `lcm`

``` purescript
lcm :: forall a. Eq a => EuclideanRing a => a -> a -> a
```

The *least common multiple* of two values.

#### `gcd`

``` purescript
gcd :: forall a. Eq a => EuclideanRing a => a -> a -> a
```

The *greatest common divisor* of two values.

#### `(/)`

``` purescript
infixl 7 div as /
```

### Re-exported from Data.Field:

#### `Field`

``` purescript
class (EuclideanRing a, DivisionRing a) <= Field a 
```

The `Field` class is for types that are (commutative) fields.

Mathematically, a field is a ring which is commutative and in which every
nonzero element has a multiplicative inverse; these conditions correspond
to the `CommutativeRing` and `DivisionRing` classes in PureScript
respectively. However, the `Field` class has `EuclideanRing` and
`DivisionRing` as superclasses, which seems like a stronger requirement
(since `CommutativeRing` is a superclass of `EuclideanRing`). In fact, it
is not stronger, since any type which has law-abiding `CommutativeRing`
and `DivisionRing` instances permits exactly one law-abiding
`EuclideanRing` instance. We use a `EuclideanRing` superclass here in
order to ensure that a `Field` constraint on a function permits you to use
`div` on that type, since `div` is a member of `EuclideanRing`.

This class has no laws or members of its own; it exists as a convenience,
so a single constraint can be used when field-like behaviour is expected.

This module also defines a single `Field` instance for any type which has
both `EuclideanRing` and `DivisionRing` instances. Any other instance
would overlap with this instance, so no other `Field` instances should be
defined in libraries. Instead, simply define `EuclideanRing` and
`DivisionRing` instances, and this will permit your type to be used with a
`Field` constraint.

##### Instances
``` purescript
(EuclideanRing a, DivisionRing a) => Field a
```

### Re-exported from Data.Function:

#### `flip`

``` purescript
flip :: forall a b c. (a -> b -> c) -> b -> a -> c
```

Given a function that takes two arguments, applies the arguments
to the function in a swapped order.

```purescript
flip append "1" "2" == append "2" "1" == "21"

const 1 "two" == 1

flip const 1 "two" == const "two" 1 == "two"
```

#### `const`

``` purescript
const :: forall a b. a -> b -> a
```

Returns its first argument and ignores its second.

```purescript
const 1 "hello" = 1
```

It can also be thought of as creating a function that ignores its argument:

```purescript
const 1 = \_ -> 1
```

#### `($)`

``` purescript
infixr 0 apply as $
```

Applies a function to an argument: the reverse of `(#)`.

```purescript
length $ groupBy productCategory $ filter isInStock $ products
```

is equivalent to:

```purescript
length (groupBy productCategory (filter isInStock products))
```

Or another alternative equivalent, applying chain of composed functions to
a value:

```purescript
length <<< groupBy productCategory <<< filter isInStock $ products
```

#### `(#)`

``` purescript
infixl 1 applyFlipped as #
```

Applies an argument to a function: the reverse of `($)`.

```purescript
products # filter isInStock # groupBy productCategory # length
```

is equivalent to:

```purescript
length (groupBy productCategory (filter isInStock products))
```

Or another alternative equivalent, applying a value to a chain of composed
functions:

```purescript
products # filter isInStock >>> groupBy productCategory >>> length
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

### Re-exported from Data.HeytingAlgebra:

#### `HeytingAlgebra`

``` purescript
class HeytingAlgebra a  where
  conj :: a -> a -> a
  disj :: a -> a -> a
  not :: a -> a
```

The `HeytingAlgebra` type class represents types that are bounded lattices with
an implication operator such that the following laws hold:

- Associativity:
  - `a || (b || c) = (a || b) || c`
  - `a && (b && c) = (a && b) && c`
- Commutativity:
  - `a || b = b || a`
  - `a && b = b && a`
- Absorption:
  - `a || (a && b) = a`
  - `a && (a || b) = a`
- Idempotent:
  - `a || a = a`
  - `a && a = a`
- Identity:
  - `a || ff = a`
  - `a && tt = a`
- Implication:
  - ``a `implies` a = tt``
  - ``a && (a `implies` b) = a && b``
  - ``b && (a `implies` b) = b``
  - ``a `implies` (b && c) = (a `implies` b) && (a `implies` c)``
- Complemented:
  - ``not a = a `implies` ff``

##### Instances
``` purescript
HeytingAlgebra Boolean
HeytingAlgebra Unit
(HeytingAlgebra b) => HeytingAlgebra (a -> b)
HeytingAlgebra (Proxy a)
(RowToList row list, HeytingAlgebraRecord list row row) => HeytingAlgebra (Record row)
```

#### `(||)`

``` purescript
infixr 2 disj as ||
```

#### `(&&)`

``` purescript
infixr 3 conj as &&
```

### Re-exported from Data.Monoid:

#### `Monoid`

``` purescript
class (Semigroup m) <= Monoid m  where
  mempty :: m
```

A `Monoid` is a `Semigroup` with a value `mempty`, which is both a
left and right unit for the associative operation `<>`:

- Left unit: `(mempty <> x) = x`
- Right unit: `(x <> mempty) = x`

`Monoid`s are commonly used as the result of fold operations, where
`<>` is used to combine individual results, and `mempty` gives the result
of folding an empty collection of elements.

### Newtypes for Monoid

Some types (e.g. `Int`, `Boolean`) can implement multiple law-abiding
instances for `Monoid`. Let's use `Int` as an example
1. `<>` could be `+` and `mempty` could be `0`
2. `<>` could be `*` and `mempty` could be `1`.

To clarify these ambiguous situations, one should use the newtypes
defined in `Data.Monoid.<NewtypeName>` modules.

In the above ambiguous situation, we could use `Additive`
for the first situation or `Multiplicative` for the second one.

##### Instances
``` purescript
Monoid Unit
Monoid Ordering
(Monoid b) => Monoid (a -> b)
Monoid String
Monoid (Array a)
(RowToList row list, MonoidRecord list row row) => Monoid (Record row)
```

### Re-exported from Data.NaturalTransformation:

#### `type (~>)`

``` purescript
infixr 4 type NaturalTransformation as ype (~>
```

### Re-exported from Data.Ord:

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

#### `comparing`

``` purescript
comparing :: forall a b. Ord b => (a -> b) -> (a -> a -> Ordering)
```

Compares two values by mapping them to a type with an `Ord` instance.

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

#### `(>=)`

``` purescript
infixl 4 greaterThanOrEq as >=
```

#### `(>)`

``` purescript
infixl 4 greaterThan as >
```

#### `(<=)`

``` purescript
infixl 4 lessThanOrEq as <=
```

#### `(<)`

``` purescript
infixl 4 lessThan as <
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

### Re-exported from Data.Ring:

#### `Ring`

``` purescript
class (Semiring a) <= Ring a  where
  sub :: a -> a -> a
```

The `Ring` class is for types that support addition, multiplication,
and subtraction operations.

Instances must satisfy the following laws in addition to the `Semiring`
laws:

- Additive inverse: `a - a = zero`
- Compatibility of `sub` and `negate`: `a - b = a + (zero - b)`

##### Instances
``` purescript
Ring Int
Ring Number
Ring Unit
(Ring b) => Ring (a -> b)
Ring (Proxy a)
(RowToList row list, RingRecord list row row) => Ring (Record row)
```

#### `negate`

``` purescript
negate :: forall a. Ring a => a -> a
```

`negate x` can be used as a shorthand for `zero - x`.

#### `(-)`

``` purescript
infixl 6 sub as -
```

### Re-exported from Data.Semigroup:

#### `Semigroup`

``` purescript
class Semigroup a  where
  append :: a -> a -> a
```

The `Semigroup` type class identifies an associative operation on a type.

Instances are required to satisfy the following law:

- Associativity: `(x <> y) <> z = x <> (y <> z)`

One example of a `Semigroup` is `String`, with `(<>)` defined as string
concatenation. Another example is `List a`, with `(<>)` defined as
list concatenation.

### Newtypes for Semigroup

There are two other ways to implement an instance for this type class
regardless of which type is used. These instances can be used by
wrapping the values in one of the two newtypes below:
1. `First` - Use the first argument every time: `append first _ = first`.
2. `Last` - Use the last argument every time: `append _ last = last`.

##### Instances
``` purescript
Semigroup String
Semigroup Unit
Semigroup Void
(Semigroup s') => Semigroup (s -> s')
Semigroup (Array a)
Semigroup (Proxy a)
(RowToList row list, SemigroupRecord list row row) => Semigroup (Record row)
```

#### `(<>)`

``` purescript
infixr 5 append as <>
```

### Re-exported from Data.Semiring:

#### `Semiring`

``` purescript
class Semiring a  where
  add :: a -> a -> a
  zero :: a
  mul :: a -> a -> a
  one :: a
```

The `Semiring` class is for types that support an addition and
multiplication operation.

Instances must satisfy the following laws:

- Commutative monoid under addition:
  - Associativity: `(a + b) + c = a + (b + c)`
  - Identity: `zero + a = a + zero = a`
  - Commutative: `a + b = b + a`
- Monoid under multiplication:
  - Associativity: `(a * b) * c = a * (b * c)`
  - Identity: `one * a = a * one = a`
- Multiplication distributes over addition:
  - Left distributivity: `a * (b + c) = (a * b) + (a * c)`
  - Right distributivity: `(a + b) * c = (a * c) + (b * c)`
- Annihilation: `zero * a = a * zero = zero`

**Note:** The `Number` and `Int` types are not fully law abiding
members of this class hierarchy due to the potential for arithmetic
overflows, and in the case of `Number`, the presence of `NaN` and
`Infinity` values. The behaviour is unspecified in these cases.

##### Instances
``` purescript
Semiring Int
Semiring Number
(Semiring b) => Semiring (a -> b)
Semiring Unit
Semiring (Proxy a)
(RowToList row list, SemiringRecord list row row) => Semiring (Record row)
```

#### `(+)`

``` purescript
infixl 6 add as +
```

#### `(*)`

``` purescript
infixl 7 mul as *
```

### Re-exported from Data.Show:

#### `Show`

``` purescript
class Show a  where
  show :: a -> String
```

The `Show` type class represents those types which can be converted into
a human-readable `String` representation.

While not required, it is recommended that for any expression `x`, the
string `show x` be executable PureScript code which evaluates to the same
value as the expression `x`.

##### Instances
``` purescript
Show Boolean
Show Int
Show Number
Show Char
Show String
(Show a) => Show (Array a)
Show (Proxy a)
(Nub rs rs, RowToList rs ls, ShowRecordFields ls rs) => Show (Record rs)
```

### Re-exported from Data.Unit:

#### `Unit`

``` purescript
data Unit
```

The `Unit` type has a single inhabitant, called `unit`. It represents
values with no computational content.

`Unit` is often used, wrapped in a monadic type constructor, as the
return type of a computation where only the _effects_ are important.

When returning a value of type `Unit` from an FFI function, it is
recommended to use `undefined`, or not return a value at all.

##### Instances
``` purescript
Show Unit
```

#### `unit`

``` purescript
unit :: Unit
```

`unit` is the sole inhabitant of the `Unit` type.

### Re-exported from Data.Void:

#### `Void`

``` purescript
newtype Void
```

An uninhabited data type. In other words, one can never create
a runtime value of type `Void` because no such value exists.

`Void` is useful to eliminate the possibility of a value being created.
For example, a value of type `Either Void Boolean` can never have
a Left value created in PureScript.

This should not be confused with the keyword `void` that commonly appears in
C-family languages, such as Java:
```
public class Foo {
  void doSomething() { System.out.println("hello world!"); }
}
```

In PureScript, one often uses `Unit` to achieve similar effects as
the `void` of C-family languages above.

##### Instances
``` purescript
Show Void
```

#### `absurd`

``` purescript
absurd :: forall a. Void -> a
```

Eliminator for the `Void` type.
Useful for stating that some code branch is impossible because you've
"acquired" a value of type `Void` (which you can't).

```purescript
rightOnly :: forall t . Either Void t -> t
rightOnly (Left v) = absurd v
rightOnly (Right t) = t
```

