## Module Data.Boolean

#### `otherwise`

``` purescript
otherwise :: Boolean
```

An alias for `true`, which can be useful in guard clauses:

```purescript
max x y | x >= y    = x
        | otherwise = y
```


