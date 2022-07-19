## Module Data.Map

#### `keys`

``` purescript
keys :: forall k v. Map k v -> Set k
```

The set of keys of the given map.
See also `Data.Set.fromMap`.

#### `SemigroupMap`

``` purescript
newtype SemigroupMap k v
  = SemigroupMap (Map k v)
```

`SemigroupMap k v` provides a `Semigroup` instance for `Map k v` whose
definition depends on the `Semigroup` instance for the `v` type.
You should only use this type when you need `Data.Map` to have
a `Semigroup` instance.

```purescript
let
  s :: forall key value. key -> value -> SemigroupMap key value
  s k v = SemigroupMap (singleton k v)

(s 1     "foo") <> (s 1     "bar") == (s 1  "foobar")
(s 1 (First 1)) <> (s 1 (First 2)) == (s 1 (First 1))
(s 1  (Last 1)) <> (s 1  (Last 2)) == (s 1  (Last 2))
```

##### Instances
``` purescript
(Eq k) => Eq1 (SemigroupMap k)
(Eq k, Eq v) => Eq (SemigroupMap k v)
(Ord k) => Ord1 (SemigroupMap k)
(Ord k, Ord v) => Ord (SemigroupMap k v)
Newtype (SemigroupMap k v) _
(Show k, Show v) => Show (SemigroupMap k v)
(Ord k, Semigroup v) => Semigroup (SemigroupMap k v)
(Ord k, Semigroup v) => Monoid (SemigroupMap k v)
(Ord k) => Alt (SemigroupMap k)
(Ord k) => Plus (SemigroupMap k)
Functor (SemigroupMap k)
FunctorWithIndex k (SemigroupMap k)
(Ord k) => Apply (SemigroupMap k)
(Ord k) => Bind (SemigroupMap k)
Foldable (SemigroupMap k)
FoldableWithIndex k (SemigroupMap k)
Traversable (SemigroupMap k)
TraversableWithIndex k (SemigroupMap k)
```


### Re-exported from Data.Map.Internal:

#### `Map`

``` purescript
data Map k v
```

`Map k v` represents maps from keys of type `k` to values of type `v`.

##### Instances
``` purescript
(Eq k) => Eq1 (Map k)
(Eq k, Eq v) => Eq (Map k v)
(Ord k) => Ord1 (Map k)
(Ord k, Ord v) => Ord (Map k v)
(Show k, Show v) => Show (Map k v)
(Warn (Text "Data.Map\'s `Semigroup` instance is now unbiased and differs from the left-biased instance defined in PureScript releases <= 0.13.x."), Ord k, Semigroup v) => Semigroup (Map k v)
(Warn (Text "Data.Map\'s `Semigroup` instance is now unbiased and differs from the left-biased instance defined in PureScript releases <= 0.13.x."), Ord k, Semigroup v) => Monoid (Map k v)
(Ord k) => Alt (Map k)
(Ord k) => Plus (Map k)
Functor (Map k)
FunctorWithIndex k (Map k)
(Ord k) => Apply (Map k)
(Ord k) => Bind (Map k)
Foldable (Map k)
FoldableWithIndex k (Map k)
Traversable (Map k)
TraversableWithIndex k (Map k)
```

#### `values`

``` purescript
values :: forall k v. Map k v -> List v
```

Get a list of the values contained in a map

#### `update`

``` purescript
update :: forall k v. Ord k => (v -> Maybe v) -> k -> Map k v -> Map k v
```

Update or delete the value for a key in a map

#### `unions`

``` purescript
unions :: forall k v f. Ord k => Foldable f => f (Map k v) -> Map k v
```

Compute the union of a collection of maps

#### `unionWith`

``` purescript
unionWith :: forall k v. Ord k => (v -> v -> v) -> Map k v -> Map k v -> Map k v
```

Compute the union of two maps, using the specified function
to combine values for duplicate keys.

#### `union`

``` purescript
union :: forall k v. Ord k => Map k v -> Map k v -> Map k v
```

Compute the union of two maps, preferring values from the first map in the case
of duplicate keys

#### `toUnfoldableUnordered`

``` purescript
toUnfoldableUnordered :: forall f k v. Unfoldable f => Map k v -> f (Tuple k v)
```

Convert a map to an unfoldable structure of key/value pairs

While this traversal is up to 10% faster in benchmarks than `toUnfoldable`,
it leaks the underlying map stucture, making it only suitable for applications
where order is irrelevant.

If you are unsure, use `toUnfoldable`

#### `toUnfoldable`

``` purescript
toUnfoldable :: forall f k v. Unfoldable f => Map k v -> f (Tuple k v)
```

Convert a map to an unfoldable structure of key/value pairs where the keys are in ascending order

#### `submap`

``` purescript
submap :: forall k v. Ord k => Maybe k -> Maybe k -> Map k v -> Map k v
```

Returns a new map containing all entries of the given map which lie
between a given lower and upper bound, treating `Nothing` as no bound i.e.
including the smallest (or largest) key in the map, no matter how small
(or large) it is. For example:

```purescript
submap (Just 1) (Just 2)
  (fromFoldable [Tuple 0 "zero", Tuple 1 "one", Tuple 2 "two", Tuple 3 "three"])
  == fromFoldable [Tuple 1 "one", Tuple 2 "two"]

submap Nothing (Just 2)
  (fromFoldable [Tuple 0 "zero", Tuple 1 "one", Tuple 2 "two", Tuple 3 "three"])
  == fromFoldable [Tuple 0 "zero", Tuple 1 "one", Tuple 2 "two"]
```

The function is entirely specified by the following
property:

```purescript
Given any m :: Map k v, mmin :: Maybe k, mmax :: Maybe k, key :: k,
  let m' = submap mmin mmax m in
    if (maybe true (\min -> min <= key) mmin &&
        maybe true (\max -> max >= key) mmax)
      then lookup key m == lookup key m'
      else not (member key m')
```

#### `size`

``` purescript
size :: forall k v. Map k v -> Int
```

Calculate the number of key/value pairs in a map

#### `singleton`

``` purescript
singleton :: forall k v. k -> v -> Map k v
```

Create a map with one key/value pair

#### `showTree`

``` purescript
showTree :: forall k v. Show k => Show v => Map k v -> String
```

Render a `Map` as a `String`

#### `pop`

``` purescript
pop :: forall k v. Ord k => k -> Map k v -> Maybe (Tuple v (Map k v))
```

Delete a key and its corresponding value from a map, returning the value
as well as the subsequent map.

#### `member`

``` purescript
member :: forall k v. Ord k => k -> Map k v -> Boolean
```

Test if a key is a member of a map

#### `mapMaybeWithKey`

``` purescript
mapMaybeWithKey :: forall k a b. Ord k => (k -> a -> Maybe b) -> Map k a -> Map k b
```

Applies a function to each key/value pair in a map, discarding entries
where the function returns `Nothing`.

#### `mapMaybe`

``` purescript
mapMaybe :: forall k a b. Ord k => (a -> Maybe b) -> Map k a -> Map k b
```

Applies a function to each value in a map, discarding entries where the
function returns `Nothing`.

#### `lookupLT`

``` purescript
lookupLT :: forall k v. Ord k => k -> Map k v -> Maybe { key :: k, value :: v }
```

Look up a value for the greatest key less than the specified key

#### `lookupLE`

``` purescript
lookupLE :: forall k v. Ord k => k -> Map k v -> Maybe { key :: k, value :: v }
```

Look up a value for the specified key, or the greatest one less than it

#### `lookupGT`

``` purescript
lookupGT :: forall k v. Ord k => k -> Map k v -> Maybe { key :: k, value :: v }
```

Look up a value for the least key greater than the specified key

#### `lookupGE`

``` purescript
lookupGE :: forall k v. Ord k => k -> Map k v -> Maybe { key :: k, value :: v }
```

Look up a value for the specified key, or the least one greater than it

#### `lookup`

``` purescript
lookup :: forall k v. Ord k => k -> Map k v -> Maybe v
```

Look up a value for the specified key

#### `isSubmap`

``` purescript
isSubmap :: forall k v. Ord k => Eq v => Map k v -> Map k v -> Boolean
```

Test whether one map contains all of the keys and values contained in another map

#### `isEmpty`

``` purescript
isEmpty :: forall k v. Map k v -> Boolean
```

Test if a map is empty

#### `intersectionWith`

``` purescript
intersectionWith :: forall k a b c. Ord k => (a -> b -> c) -> Map k a -> Map k b -> Map k c
```

Compute the intersection of two maps, using the specified function
to combine values for duplicate keys.

#### `intersection`

``` purescript
intersection :: forall k a b. Ord k => Map k a -> Map k b -> Map k a
```

Compute the intersection of two maps, preferring values from the first map in the case
of duplicate keys.

#### `insertWith`

``` purescript
insertWith :: forall k v. Ord k => (v -> v -> v) -> k -> v -> Map k v -> Map k v
```

Inserts or updates a value with the given function.

The combining function is called with the existing value as the first
argument and the new value as the second argument.

#### `insert`

``` purescript
insert :: forall k v. Ord k => k -> v -> Map k v -> Map k v
```

Insert or replace a key/value pair in a map

#### `fromFoldableWithIndex`

``` purescript
fromFoldableWithIndex :: forall f k v. Ord k => FoldableWithIndex k f => f v -> Map k v
```

Convert any indexed foldable collection into a map.

#### `fromFoldableWith`

``` purescript
fromFoldableWith :: forall f k v. Ord k => Foldable f => (v -> v -> v) -> f (Tuple k v) -> Map k v
```

Convert any foldable collection of key/value pairs to a map.
On key collision, the values are configurably combined.

#### `fromFoldable`

``` purescript
fromFoldable :: forall f k v. Ord k => Foldable f => f (Tuple k v) -> Map k v
```

Convert any foldable collection of key/value pairs to a map.
On key collision, later values take precedence over earlier ones.

#### `foldSubmap`

``` purescript
foldSubmap :: forall k v m. Ord k => Monoid m => Maybe k -> Maybe k -> (k -> v -> m) -> Map k v -> m
```

Fold over the entries of a given map where the key is between a lower and
an upper bound. Passing `Nothing` as either the lower or upper bound
argument means that the fold has no lower or upper bound, i.e. the fold
starts from (or ends with) the smallest (or largest) key in the map.

```purescript
foldSubmap (Just 1) (Just 2) (\_ v -> [v])
 (fromFoldable [Tuple 0 "zero", Tuple 1 "one", Tuple 2 "two", Tuple 3 "three"])
 == ["one", "two"]

foldSubmap Nothing (Just 2) (\_ v -> [v])
 (fromFoldable [Tuple 0 "zero", Tuple 1 "one", Tuple 2 "two", Tuple 3 "three"])
 == ["zero", "one", "two"]
```

#### `findMin`

``` purescript
findMin :: forall k v. Map k v -> Maybe { key :: k, value :: v }
```

Returns the pair with the least key

#### `findMax`

``` purescript
findMax :: forall k v. Map k v -> Maybe { key :: k, value :: v }
```

Returns the pair with the greatest key

#### `filterWithKey`

``` purescript
filterWithKey :: forall k v. Ord k => (k -> v -> Boolean) -> Map k v -> Map k v
```

Filter out those key/value pairs of a map for which a predicate
fails to hold.

#### `filterKeys`

``` purescript
filterKeys :: forall k. Ord k => (k -> Boolean) -> (Map k) ~> (Map k)
```

Filter out those key/value pairs of a map for which a predicate
on the key fails to hold.

#### `filter`

``` purescript
filter :: forall k v. Ord k => (v -> Boolean) -> Map k v -> Map k v
```

Filter out those key/value pairs of a map for which a predicate
on the value fails to hold.

#### `empty`

``` purescript
empty :: forall k v. Map k v
```

An empty map

#### `difference`

``` purescript
difference :: forall k v w. Ord k => Map k v -> Map k w -> Map k v
```

Difference of two maps. Return elements of the first map where
the keys do not exist in the second map.

#### `delete`

``` purescript
delete :: forall k v. Ord k => k -> Map k v -> Map k v
```

Delete a key and its corresponding value from a map.

#### `checkValid`

``` purescript
checkValid :: forall k v. Map k v -> Boolean
```

Check whether the underlying tree satisfies the 2-3 invariant

This function is provided for internal use.

#### `catMaybes`

``` purescript
catMaybes :: forall k v. Ord k => Map k (Maybe v) -> Map k v
```

Filter a map of optional values, keeping only the key/value pairs which
contain a value, creating a new map.

#### `alter`

``` purescript
alter :: forall k v. Ord k => (Maybe v -> Maybe v) -> k -> Map k v -> Map k v
```

Insert the value, delete a value, or update a value for a key in a map

