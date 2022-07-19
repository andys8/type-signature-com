## Module Foreign

This module defines types and functions for working with _foreign_
data.

`ExceptT (NonEmptyList ForeignError) m` is used in this library
to encode possible failures when dealing with foreign data.

The `Alt` instance for `ExceptT` allows us to accumulate errors,
unlike `Either`, which preserves only the last error.

#### `Foreign`

``` purescript
data Foreign
```

A type for _foreign data_.

Foreign data is data from any external _unknown_ or _unreliable_
source, for which it cannot be guaranteed that the runtime representation
conforms to that of any particular type.

Suitable applications of `Foreign` are

- To represent responses from web services
- To integrate with external JavaScript libraries.

#### `ForeignError`

``` purescript
data ForeignError
  = ForeignError String
  | TypeMismatch String String
  | ErrorAtIndex Int ForeignError
  | ErrorAtProperty String ForeignError
```

A type for foreign type errors

##### Instances
``` purescript
Eq ForeignError
Ord ForeignError
Show ForeignError
```

#### `MultipleErrors`

``` purescript
type MultipleErrors = NonEmptyList ForeignError
```

A type for accumulating multiple `ForeignError`s.

#### `F`

``` purescript
type F = Except MultipleErrors
```

While this alias is not deprecated, it is recommended
that one use `Except (NonEmptyList ForeignError)` directly
for all future usages rather than this type alias.

An error monad, used in this library to encode possible failures when
dealing with foreign data.

The `Alt` instance for `Except` allows us to accumulate errors,
unlike `Either`, which preserves only the last error.

#### `FT`

``` purescript
type FT = ExceptT MultipleErrors
```

While this alias is not deprecated, it is recommended
that one use `ExceptT (NonEmptyList ForeignError)` directly
for all future usages rather than this type alias.

#### `renderForeignError`

``` purescript
renderForeignError :: ForeignError -> String
```

#### `unsafeToForeign`

``` purescript
unsafeToForeign :: forall a. a -> Foreign
```

Coerce any value to the a `Foreign` value.

This is considered unsafe as it's only intended to be used on primitive
JavaScript types, rather than PureScript types. Exporting PureScript values
via the FFI can be dangerous as they can be mutated by code outside the
PureScript program, resulting in difficult to diagnose problems elsewhere.

#### `unsafeFromForeign`

``` purescript
unsafeFromForeign :: forall a. Foreign -> a
```

Unsafely coerce a `Foreign` value.

#### `unsafeReadTagged`

``` purescript
unsafeReadTagged :: forall m a. Monad m => String -> Foreign -> ExceptT (NonEmptyList ForeignError) m a
```

Unsafely coerce a `Foreign` value when the value has a particular `tagOf`
value.

#### `typeOf`

``` purescript
typeOf :: Foreign -> String
```

Read the Javascript _type_ of a value

#### `tagOf`

``` purescript
tagOf :: Foreign -> String
```

Read the Javascript _tag_ of a value.

This function wraps the `Object.toString` method.

#### `isNull`

``` purescript
isNull :: Foreign -> Boolean
```

Test whether a foreign value is null

#### `isUndefined`

``` purescript
isUndefined :: Foreign -> Boolean
```

Test whether a foreign value is undefined

#### `isArray`

``` purescript
isArray :: Foreign -> Boolean
```

Test whether a foreign value is an array

#### `readString`

``` purescript
readString :: forall m. Monad m => Foreign -> ExceptT (NonEmptyList ForeignError) m String
```

Attempt to coerce a foreign value to a `String`.

#### `readChar`

``` purescript
readChar :: forall m. Monad m => Foreign -> ExceptT (NonEmptyList ForeignError) m Char
```

Attempt to coerce a foreign value to a `Char`.

#### `readBoolean`

``` purescript
readBoolean :: forall m. Monad m => Foreign -> ExceptT (NonEmptyList ForeignError) m Boolean
```

Attempt to coerce a foreign value to a `Boolean`.

#### `readNumber`

``` purescript
readNumber :: forall m. Monad m => Foreign -> ExceptT (NonEmptyList ForeignError) m Number
```

Attempt to coerce a foreign value to a `Number`.

#### `readInt`

``` purescript
readInt :: forall m. Monad m => Foreign -> ExceptT (NonEmptyList ForeignError) m Int
```

Attempt to coerce a foreign value to an `Int`.

#### `readArray`

``` purescript
readArray :: forall m. Monad m => Foreign -> ExceptT (NonEmptyList ForeignError) m (Array Foreign)
```

Attempt to coerce a foreign value to an array.

#### `readNull`

``` purescript
readNull :: forall m. Monad m => Foreign -> ExceptT (NonEmptyList ForeignError) m (Maybe Foreign)
```

#### `readUndefined`

``` purescript
readUndefined :: forall m. Monad m => Foreign -> ExceptT (NonEmptyList ForeignError) m (Maybe Foreign)
```

#### `readNullOrUndefined`

``` purescript
readNullOrUndefined :: forall m. Monad m => Foreign -> ExceptT (NonEmptyList ForeignError) m (Maybe Foreign)
```

#### `fail`

``` purescript
fail :: forall m a. Monad m => ForeignError -> ExceptT (NonEmptyList ForeignError) m a
```

Throws a failure error in `ExceptT (NonEmptyList ForeignError) m`.


