## Module Data.Unit

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


