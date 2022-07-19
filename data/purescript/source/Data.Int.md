## Module Data.Int

#### `fromNumber`

``` purescript
fromNumber :: Number -> Maybe Int
```

Creates an `Int` from a `Number` value. The number must already be an
integer and fall within the valid range of values for the `Int` type
otherwise `Nothing` is returned.

#### `ceil`

``` purescript
ceil :: Number -> Int
```

Convert a `Number` to an `Int`, by taking the closest integer equal to or
greater than the argument. Values outside the `Int` range are clamped,
`NaN` and `Infinity` values return 0.

#### `floor`

``` purescript
floor :: Number -> Int
```

Convert a `Number` to an `Int`, by taking the closest integer equal to or
less than the argument. Values outside the `Int` range are clamped, `NaN`
and `Infinity` values return 0.

#### `trunc`

``` purescript
trunc :: Number -> Int
```

Convert a `Number` to an `Int`, by dropping the decimal.
Values outside the `Int` range are clamped, `NaN` and `Infinity`
values return 0.

#### `round`

``` purescript
round :: Number -> Int
```

Convert a `Number` to an `Int`, by taking the nearest integer to the
argument. Values outside the `Int` range are clamped, `NaN` and `Infinity`
values return 0.

#### `toNumber`

``` purescript
toNumber :: Int -> Number
```

Converts an `Int` value back into a `Number`. Any `Int` is a valid `Number`
so there is no loss of precision with this function.

#### `fromString`

``` purescript
fromString :: String -> Maybe Int
```

Reads an `Int` from a `String` value. The number must parse as an integer
and fall within the valid range of values for the `Int` type, otherwise
`Nothing` is returned.

#### `Radix`

``` purescript
newtype Radix
```

The number of unique digits (including zero) used to represent integers in
a specific base.

#### `radix`

``` purescript
radix :: Int -> Maybe Radix
```

Create a `Radix` from a number between 2 and 36.

#### `binary`

``` purescript
binary :: Radix
```

The base-2 system.

#### `octal`

``` purescript
octal :: Radix
```

The base-8 system.

#### `decimal`

``` purescript
decimal :: Radix
```

The base-10 system.

#### `hexadecimal`

``` purescript
hexadecimal :: Radix
```

The base-16 system.

#### `base36`

``` purescript
base36 :: Radix
```

The base-36 system.

#### `fromStringAs`

``` purescript
fromStringAs :: Radix -> String -> Maybe Int
```

Like `fromString`, but the integer can be specified in a different base.

Example:
``` purs
fromStringAs binary      "100" == Just 4
fromStringAs hexadecimal "ff"  == Just 255
```

#### `toStringAs`

``` purescript
toStringAs :: Radix -> Int -> String
```

#### `Parity`

``` purescript
data Parity
  = Even
  | Odd
```

A type for describing whether an integer is even or odd.

The `Ord` instance considers `Even` to be less than `Odd`.

The `Semiring` instance allows you to ask about the parity of the results
of arithmetical operations, given only the parities of the inputs. For
example, the sum of an odd number and an even number is odd, so
`Odd + Even == Odd`. This also works for multiplication, eg. the product
of two odd numbers is odd, and therefore `Odd * Odd == Odd`.

More generally, we have that

```purescript
parity x + parity y == parity (x + y)
parity x * parity y == parity (x * y)
```

for any integers `x`, `y`. (A mathematician would say that `parity` is a
*ring homomorphism*.)

After defining addition and multiplication on `Parity` in this way, the
`Semiring` laws now force us to choose `zero = Even` and `one = Odd`.
This `Semiring` instance actually turns out to be a `Field`.

##### Instances
``` purescript
Eq Parity
Ord Parity
Show Parity
Bounded Parity
Semiring Parity
Ring Parity
CommutativeRing Parity
EuclideanRing Parity
DivisionRing Parity
```

#### `parity`

``` purescript
parity :: Int -> Parity
```

Returns whether an `Int` is `Even` or `Odd`.

``` purescript
parity 0 == Even
parity 1 == Odd
```

#### `even`

``` purescript
even :: Int -> Boolean
```

Returns whether an `Int` is an even number.

``` purescript
even 0 == true
even 1 == false
```

#### `odd`

``` purescript
odd :: Int -> Boolean
```

The negation of `even`.

``` purescript
odd 0 == false
odd 1 == true
```

#### `quot`

``` purescript
quot :: Int -> Int -> Int
```

The `quot` function provides _truncating_ integer division (see the
documentation for the `EuclideanRing` class). It is identical to `div` in
the `EuclideanRing Int` instance if the dividend is positive, but will be
slightly different if the dividend is negative. For example:

```purescript
div 2 3 == 0
quot 2 3 == 0

div (-2) 3 == (-1)
quot (-2) 3 == 0

div 2 (-3) == 0
quot 2 (-3) == 0
```

#### `rem`

``` purescript
rem :: Int -> Int -> Int
```

The `rem` function provides the remainder after _truncating_ integer
division (see the documentation for the `EuclideanRing` class). It is
identical to `mod` in the `EuclideanRing Int` instance if the dividend is
positive, but will be slightly different if the dividend is negative. For
example:

```purescript
mod 2 3 == 2
rem 2 3 == 2

mod (-2) 3 == 1
rem (-2) 3 == (-2)

mod 2 (-3) == 2
rem 2 (-3) == 2
```

#### `pow`

``` purescript
pow :: Int -> Int -> Int
```

Raise an Int to the power of another Int.


