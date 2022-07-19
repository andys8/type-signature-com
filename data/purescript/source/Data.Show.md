## Module Data.Show

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

#### `ShowRecordFields`

``` purescript
class ShowRecordFields rowlist row  where
  showRecordFields :: Proxy rowlist -> Record row -> Array String
```

A class for records where all fields have `Show` instances, used to
implement the `Show` instance for records.

##### Instances
``` purescript
ShowRecordFields Nil row
(IsSymbol key, ShowRecordFields rowlistTail row, Show focus) => ShowRecordFields (Cons key focus rowlistTail) row
```


