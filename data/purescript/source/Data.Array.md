## Module Data.Array

Helper functions for working with immutable Javascript arrays.

_Note_: Depending on your use-case, you may prefer to use `Data.List` or
`Data.Sequence` instead, which might give better performance for certain
use cases. This module is useful when integrating with JavaScript libraries
which use arrays, but immutable arrays are not a practical data structure
for many use cases due to their poor asymptotics.

In addition to the functions in this module, Arrays have a number of
useful instances:

* `Functor`, which provides `map :: forall a b. (a -> b) -> Array a ->
  Array b`
* `Apply`, which provides `(<*>) :: forall a b. Array (a -> b) -> Array a
  -> Array b`. This function works a bit like a Cartesian product; the
  result array is constructed by applying each function in the first
  array to each value in the second, so that the result array ends up with
  a length equal to the product of the two arguments' lengths.
* `Bind`, which provides `(>>=) :: forall a b. (a -> Array b) -> Array a
  -> Array b` (this is the same as `concatMap`).
* `Semigroup`, which provides `(<>) :: forall a. Array a -> Array a ->
  Array a`, for concatenating arrays.
* `Foldable`, which provides a slew of functions for *folding* (also known
  as *reducing*) arrays down to one value. For example,
  `Data.Foldable.or` tests whether an array of `Boolean` values contains
  at least one `true` value.
* `Traversable`, which provides the PureScript version of a for-loop,
  allowing you to STAI.iterate over an array and accumulate effects.


#### `fromFoldable`

``` purescript
fromFoldable :: forall f. Foldable f => f ~> Array
```

Convert a `Foldable` structure into an `Array`.

```purescript
fromFoldable (Just 1) = [1]
fromFoldable (Nothing) = []
```


#### `toUnfoldable`

``` purescript
toUnfoldable :: forall f. Unfoldable f => Array ~> f
```

Convert an `Array` into an `Unfoldable` structure.

#### `singleton`

``` purescript
singleton :: forall a. a -> Array a
```

Create an array of one element
```purescript
singleton 2 = [2]
```

#### `(..)`

``` purescript
infix 8 range as ..
```

An infix synonym for `range`.
```purescript
2 .. 5 = [2, 3, 4, 5]
```

#### `range`

``` purescript
range :: Int -> Int -> Array Int
```

Create an array containing a range of integers, including both endpoints.
```purescript
range 2 5 = [2, 3, 4, 5]
```

#### `replicate`

``` purescript
replicate :: forall a. Int -> a -> Array a
```

Create an array containing a value repeated the specified number of times.
```purescript
replicate 2 "Hi" = ["Hi", "Hi"]
```

#### `some`

``` purescript
some :: forall f a. Alternative f => Lazy (f (Array a)) => f a -> f (Array a)
```

Attempt a computation multiple times, requiring at least one success.

The `Lazy` constraint is used to generate the result lazily, to ensure
termination.

#### `many`

``` purescript
many :: forall f a. Alternative f => Lazy (f (Array a)) => f a -> f (Array a)
```

Attempt a computation multiple times, returning as many successful results
as possible (possibly zero).

The `Lazy` constraint is used to generate the result lazily, to ensure
termination.

#### `null`

``` purescript
null :: forall a. Array a -> Boolean
```

Test whether an array is empty.
```purescript
null [] = true
null [1, 2] = false
```

#### `length`

``` purescript
length :: forall a. Array a -> Int
```

Get the number of elements in an array.
```purescript
length ["Hello", "World"] = 2
```

#### `(:)`

``` purescript
infixr 6 cons as :
```

An infix alias for `cons`.

```purescript
1 : [2, 3, 4] = [1, 2, 3, 4]
```

Note, the running time of this function is `O(n)`.

#### `cons`

``` purescript
cons :: forall a. a -> Array a -> Array a
```

Attaches an element to the front of an array, creating a new array.

```purescript
cons 1 [2, 3, 4] = [1, 2, 3, 4]
```

Note, the running time of this function is `O(n)`.

#### `snoc`

``` purescript
snoc :: forall a. Array a -> a -> Array a
```

Append an element to the end of an array, creating a new array.

```purescript
snoc [1, 2, 3] 4 = [1, 2, 3, 4]
```


#### `insert`

``` purescript
insert :: forall a. Ord a => a -> Array a -> Array a
```

Insert an element into a sorted array.

```purescript
insert 10 [1, 2, 20, 21] = [1, 2, 10, 20, 21]
```


#### `insertBy`

``` purescript
insertBy :: forall a. (a -> a -> Ordering) -> a -> Array a -> Array a
```

Insert an element into a sorted array, using the specified function to
determine the ordering of elements.

```purescript
invertCompare a b = invert $ compare a b

insertBy invertCompare 10 [21, 20, 2, 1] = [21, 20, 10, 2, 1]
```


#### `head`

``` purescript
head :: forall a. Array a -> Maybe a
```

Get the first element in an array, or `Nothing` if the array is empty

Running time: `O(1)`.

```purescript
head [1, 2] = Just 1
head [] = Nothing
```


#### `last`

``` purescript
last :: forall a. Array a -> Maybe a
```

Get the last element in an array, or `Nothing` if the array is empty

Running time: `O(1)`.

```purescript
last [1, 2] = Just 2
last [] = Nothing
```


#### `tail`

``` purescript
tail :: forall a. Array a -> Maybe (Array a)
```

Get all but the first element of an array, creating a new array, or
`Nothing` if the array is empty

```purescript
tail [1, 2, 3, 4] = Just [2, 3, 4]
tail [] = Nothing
```

Running time: `O(n)` where `n` is the length of the array

#### `init`

``` purescript
init :: forall a. Array a -> Maybe (Array a)
```

Get all but the last element of an array, creating a new array, or
`Nothing` if the array is empty.

```purescript
init [1, 2, 3, 4] = Just [1, 2, 3]
init [] = Nothing
```

Running time: `O(n)` where `n` is the length of the array

#### `uncons`

``` purescript
uncons :: forall a. Array a -> Maybe { head :: a, tail :: Array a }
```

Break an array into its first element and remaining elements.

Using `uncons` provides a way of writing code that would use cons patterns
in Haskell or pre-PureScript 0.7:
``` purescript
f (x : xs) = something
f [] = somethingElse
```
Becomes:
``` purescript
f arr = case uncons arr of
  Just { head: x, tail: xs } -> something
  Nothing -> somethingElse
```

#### `unsnoc`

``` purescript
unsnoc :: forall a. Array a -> Maybe { init :: Array a, last :: a }
```

Break an array into its last element and all preceding elements.

```purescript
unsnoc [1, 2, 3] = Just {init: [1, 2], last: 3}
unsnoc [] = Nothing
```

Running time: `O(n)` where `n` is the length of the array

#### `(!!)`

``` purescript
infixl 8 index as !!
```

An infix version of `index`.

```purescript
sentence = ["Hello", "World", "!"]

sentence !! 0 = Just "Hello"
sentence !! 7 = Nothing
```


#### `index`

``` purescript
index :: forall a. Array a -> Int -> Maybe a
```

This function provides a safe way to read a value at a particular index
from an array.

```purescript
sentence = ["Hello", "World", "!"]

index sentence 0 = Just "Hello"
index sentence 7 = Nothing
```


#### `elem`

``` purescript
elem :: forall a. Eq a => a -> Array a -> Boolean
```

Returns true if the array has the given element.

#### `notElem`

``` purescript
notElem :: forall a. Eq a => a -> Array a -> Boolean
```

Returns true if the array does not have the given element.

#### `elemIndex`

``` purescript
elemIndex :: forall a. Eq a => a -> Array a -> Maybe Int
```

Find the index of the first element equal to the specified element.

```purescript
elemIndex "a" ["a", "b", "a", "c"] = Just 0
elemIndex "Earth" ["Hello", "World", "!"] = Nothing
```


#### `elemLastIndex`

``` purescript
elemLastIndex :: forall a. Eq a => a -> Array a -> Maybe Int
```

Find the index of the last element equal to the specified element.

```purescript
elemLastIndex "a" ["a", "b", "a", "c"] = Just 2
elemLastIndex "Earth" ["Hello", "World", "!"] = Nothing
```


#### `find`

``` purescript
find :: forall a. (a -> Boolean) -> Array a -> Maybe a
```

Find the first element for which a predicate holds.

```purescript
find (contains $ Pattern "b") ["a", "bb", "b", "d"] = Just "bb"
find (contains $ Pattern "x") ["a", "bb", "b", "d"] = Nothing
```

#### `findMap`

``` purescript
findMap :: forall a b. (a -> Maybe b) -> Array a -> Maybe b
```

Find the first element in a data structure which satisfies
a predicate mapping.

#### `findIndex`

``` purescript
findIndex :: forall a. (a -> Boolean) -> Array a -> Maybe Int
```

Find the first index for which a predicate holds.

```purescript
findIndex (contains $ Pattern "b") ["a", "bb", "b", "d"] = Just 1
findIndex (contains $ Pattern "x") ["a", "bb", "b", "d"] = Nothing
```


#### `findLastIndex`

``` purescript
findLastIndex :: forall a. (a -> Boolean) -> Array a -> Maybe Int
```

Find the last index for which a predicate holds.

```purescript
findLastIndex (contains $ Pattern "b") ["a", "bb", "b", "d"] = Just 2
findLastIndex (contains $ Pattern "x") ["a", "bb", "b", "d"] = Nothing
```


#### `insertAt`

``` purescript
insertAt :: forall a. Int -> a -> Array a -> Maybe (Array a)
```

Insert an element at the specified index, creating a new array, or
returning `Nothing` if the index is out of bounds.

```purescript
insertAt 2 "!" ["Hello", "World"] = Just ["Hello", "World", "!"]
insertAt 10 "!" ["Hello"] = Nothing
```


#### `deleteAt`

``` purescript
deleteAt :: forall a. Int -> Array a -> Maybe (Array a)
```

Delete the element at the specified index, creating a new array, or
returning `Nothing` if the index is out of bounds.

```purescript
deleteAt 0 ["Hello", "World"] = Just ["World"]
deleteAt 10 ["Hello", "World"] = Nothing
```


#### `updateAt`

``` purescript
updateAt :: forall a. Int -> a -> Array a -> Maybe (Array a)
```

Change the element at the specified index, creating a new array, or
returning `Nothing` if the index is out of bounds.

```purescript
updateAt 1 "World" ["Hello", "Earth"] = Just ["Hello", "World"]
updateAt 10 "World" ["Hello", "Earth"] = Nothing
```


#### `updateAtIndices`

``` purescript
updateAtIndices :: forall t a. Foldable t => t (Tuple Int a) -> Array a -> Array a
```

Change the elements at the specified indices in index/value pairs.
Out-of-bounds indices will have no effect.

```purescript
updates = [Tuple 0 "Hi", Tuple 2 "." , Tuple 10 "foobar"]

updateAtIndices updates ["Hello", "World", "!"] = ["Hi", "World", "."]
```


#### `modifyAt`

``` purescript
modifyAt :: forall a. Int -> (a -> a) -> Array a -> Maybe (Array a)
```

Apply a function to the element at the specified index, creating a new
array, or returning `Nothing` if the index is out of bounds.

```purescript
modifyAt 1 toUpper ["Hello", "World"] = Just ["Hello", "WORLD"]
modifyAt 10 toUpper ["Hello", "World"] = Nothing
```


#### `modifyAtIndices`

``` purescript
modifyAtIndices :: forall t a. Foldable t => t Int -> (a -> a) -> Array a -> Array a
```

Apply a function to the element at the specified indices,
creating a new array. Out-of-bounds indices will have no effect.

```purescript
indices = [1, 3]
modifyAtIndices indices toUpper ["Hello", "World", "and", "others"]
   = ["Hello", "WORLD", "and", "OTHERS"]
```


#### `alterAt`

``` purescript
alterAt :: forall a. Int -> (a -> Maybe a) -> Array a -> Maybe (Array a)
```

Update or delete the element at the specified index by applying a
function to the current value, returning a new array or `Nothing` if the
index is out-of-bounds.

```purescript
alterAt 1 (stripSuffix $ Pattern "!") ["Hello", "World!"]
   = Just ["Hello", "World"]

alterAt 1 (stripSuffix $ Pattern "!!!!!") ["Hello", "World!"]
   = Just ["Hello"]

alterAt 10 (stripSuffix $ Pattern "!") ["Hello", "World!"] = Nothing
```


#### `intersperse`

``` purescript
intersperse :: forall a. a -> Array a -> Array a
```

Inserts the given element in between each element in the array. The array
must have two or more elements for this operation to take effect.

```purescript
intersperse " " [ "a", "b" ] == [ "a", " ", "b" ]
intersperse 0 [ 1, 2, 3, 4, 5 ] == [ 1, 0, 2, 0, 3, 0, 4, 0, 5 ]
```

If the array has less than two elements, the input array is returned.
```purescript
intersperse " " [] == []
intersperse " " ["a"] == ["a"]
```

#### `reverse`

``` purescript
reverse :: forall a. Array a -> Array a
```

Reverse an array, creating a new array.

```purescript
reverse [] = []
reverse [1, 2, 3] = [3, 2, 1]
```


#### `concat`

``` purescript
concat :: forall a. Array (Array a) -> Array a
```

Flatten an array of arrays, creating a new array.

```purescript
concat [[1, 2, 3], [], [4, 5, 6]] = [1, 2, 3, 4, 5, 6]
```


#### `concatMap`

``` purescript
concatMap :: forall a b. (a -> Array b) -> Array a -> Array b
```

Apply a function to each element in an array, and flatten the results
into a single, new array.

```purescript
concatMap (split $ Pattern " ") ["Hello World", "other thing"]
   = ["Hello", "World", "other", "thing"]
```


#### `filter`

``` purescript
filter :: forall a. (a -> Boolean) -> Array a -> Array a
```

Filter an array, keeping the elements which satisfy a predicate function,
creating a new array.

```purescript
filter (_ > 0) [-1, 4, -5, 7] = [4, 7]
```


#### `partition`

``` purescript
partition :: forall a. (a -> Boolean) -> Array a -> { no :: Array a, yes :: Array a }
```

Partition an array using a predicate function, creating a set of
new arrays. One for the values satisfying the predicate function
and one for values that don't.

```purescript
partition (_ > 0) [-1, 4, -5, 7] = { yes: [4, 7], no: [-1, -5] }
```


#### `splitAt`

``` purescript
splitAt :: forall a. Int -> Array a -> { after :: Array a, before :: Array a }
```

Splits an array into two subarrays, where `before` contains the elements
up to (but not including) the given index, and `after` contains the rest
of the elements, from that index on.

```purescript
>>> splitAt 3 [1, 2, 3, 4, 5]
{ before: [1, 2, 3], after: [4, 5] }
```

Thus, the length of `(splitAt i arr).before` will equal either `i` or
`length arr`, if that is shorter. (Or if `i` is negative the length will
be 0.)

```purescript
splitAt 2 ([] :: Array Int) == { before: [], after: [] }
splitAt 3 [1, 2, 3, 4, 5] == { before: [1, 2, 3], after: [4, 5] }
```

#### `filterA`

``` purescript
filterA :: forall a f. Applicative f => (a -> f Boolean) -> Array a -> f (Array a)
```

Filter where the predicate returns a `Boolean` in some `Applicative`.

```purescript
powerSet :: forall a. Array a -> Array (Array a)
powerSet = filterA (const [true, false])
```

#### `mapMaybe`

``` purescript
mapMaybe :: forall a b. (a -> Maybe b) -> Array a -> Array b
```

Apply a function to each element in an array, keeping only the results
which contain a value, creating a new array.

```purescript
parseEmail :: String -> Maybe Email
parseEmail = ...

mapMaybe parseEmail ["a.com", "hello@example.com", "--"]
   = [Email {user: "hello", domain: "example.com"}]
```


#### `catMaybes`

``` purescript
catMaybes :: forall a. Array (Maybe a) -> Array a
```

Filter an array of optional values, keeping only the elements which contain
a value, creating a new array.

```purescript
catMaybes [Nothing, Just 2, Nothing, Just 4] = [2, 4]
```


#### `mapWithIndex`

``` purescript
mapWithIndex :: forall a b. (Int -> a -> b) -> Array a -> Array b
```

Apply a function to each element in an array, supplying a generated
zero-based index integer along with the element, creating an array
with the new elements.

```purescript
prefixIndex index element = show index <> element

mapWithIndex prefixIndex ["Hello", "World"] = ["0Hello", "1World"]
```


#### `foldl`

``` purescript
foldl :: forall a b. (b -> a -> b) -> b -> Array a -> b
```

#### `foldr`

``` purescript
foldr :: forall a b. (a -> b -> b) -> b -> Array a -> b
```

#### `foldMap`

``` purescript
foldMap :: forall a m. Monoid m => (a -> m) -> Array a -> m
```

#### `fold`

``` purescript
fold :: forall m. Monoid m => Array m -> m
```

#### `intercalate`

``` purescript
intercalate :: forall a. Monoid a => a -> Array a -> a
```

#### `scanl`

``` purescript
scanl :: forall a b. (b -> a -> b) -> b -> Array a -> Array b
```

Fold a data structure from the left, keeping all intermediate results
instead of only the final result. Note that the initial value does not
appear in the result (unlike Haskell's `Prelude.scanl`).

```
scanl (+) 0  [1,2,3] = [1,3,6]
scanl (-) 10 [1,2,3] = [9,7,4]
```

#### `scanr`

``` purescript
scanr :: forall a b. (a -> b -> b) -> b -> Array a -> Array b
```

Fold a data structure from the right, keeping all intermediate results
instead of only the final result. Note that the initial value does not
appear in the result (unlike Haskell's `Prelude.scanr`).

```
scanr (+) 0 [1,2,3] = [6,5,3]
scanr (flip (-)) 10 [1,2,3] = [4,5,7]
```

#### `sort`

``` purescript
sort :: forall a. Ord a => Array a -> Array a
```

Sort the elements of an array in increasing order, creating a new array.
Sorting is stable: the order of equal elements is preserved.

```purescript
sort [2, -3, 1] = [-3, 1, 2]
```


#### `sortBy`

``` purescript
sortBy :: forall a. (a -> a -> Ordering) -> Array a -> Array a
```

Sort the elements of an array in increasing order, where elements are
compared using the specified partial ordering, creating a new array.
Sorting is stable: the order of elements is preserved if they are equal
according to the specified partial ordering.

```purescript
compareLength a b = compare (length a) (length b)
sortBy compareLength [[1, 2, 3], [7, 9], [-2]] = [[-2],[7,9],[1,2,3]]
```


#### `sortWith`

``` purescript
sortWith :: forall a b. Ord b => (a -> b) -> Array a -> Array a
```

Sort the elements of an array in increasing order, where elements are
sorted based on a projection. Sorting is stable: the order of elements is
preserved if they are equal according to the projection.

```purescript
sortWith (_.age) [{name: "Alice", age: 42}, {name: "Bob", age: 21}]
   = [{name: "Bob", age: 21}, {name: "Alice", age: 42}]
```


#### `slice`

``` purescript
slice :: forall a. Int -> Int -> Array a -> Array a
```

Extract a subarray by a start and end index.

```purescript
letters = ["a", "b", "c"]
slice 1 3 letters = ["b", "c"]
slice 5 7 letters = []
slice 4 1 letters = []
```


#### `take`

``` purescript
take :: forall a. Int -> Array a -> Array a
```

Keep only a number of elements from the start of an array, creating a new
array.

```purescript
letters = ["a", "b", "c"]

take 2 letters = ["a", "b"]
take 100 letters = ["a", "b", "c"]
```


#### `takeEnd`

``` purescript
takeEnd :: forall a. Int -> Array a -> Array a
```

Keep only a number of elements from the end of an array, creating a new
array.

```purescript
letters = ["a", "b", "c"]

takeEnd 2 letters = ["b", "c"]
takeEnd 100 letters = ["a", "b", "c"]
```


#### `takeWhile`

``` purescript
takeWhile :: forall a. (a -> Boolean) -> Array a -> Array a
```

Calculate the longest initial subarray for which all element satisfy the
specified predicate, creating a new array.

```purescript
takeWhile (_ > 0) [4, 1, 0, -4, 5] = [4, 1]
takeWhile (_ > 0) [-1, 4] = []
```


#### `drop`

``` purescript
drop :: forall a. Int -> Array a -> Array a
```

Drop a number of elements from the start of an array, creating a new array.

```purescript
letters = ["a", "b", "c", "d"]

drop 2 letters = ["c", "d"]
drop 10 letters = []
```


#### `dropEnd`

``` purescript
dropEnd :: forall a. Int -> Array a -> Array a
```

Drop a number of elements from the end of an array, creating a new array.

```purescript
letters = ["a", "b", "c", "d"]

dropEnd 2 letters = ["a", "b"]
dropEnd 10 letters = []
```


#### `dropWhile`

``` purescript
dropWhile :: forall a. (a -> Boolean) -> Array a -> Array a
```

Remove the longest initial subarray for which all element satisfy the
specified predicate, creating a new array.

```purescript
dropWhile (_ < 0) [-3, -1, 0, 4, -6] = [0, 4, -6]
```


#### `span`

``` purescript
span :: forall a. (a -> Boolean) -> Array a -> { init :: Array a, rest :: Array a }
```

Split an array into two parts:

1. the longest initial subarray for which all elements satisfy the
   specified predicate
2. the remaining elements

```purescript
span (\n -> n % 2 == 1) [1,3,2,4,5] == { init: [1,3], rest: [2,4,5] }
```

Running time: `O(n)`.

#### `group`

``` purescript
group :: forall a. Eq a => Array a -> Array (NonEmptyArray a)
```

Group equal, consecutive elements of an array into arrays.

```purescript
group [1, 1, 2, 2, 1] == [NonEmptyArray [1, 1], NonEmptyArray [2, 2], NonEmptyArray [1]]
```

#### `groupAll`

``` purescript
groupAll :: forall a. Ord a => Array a -> Array (NonEmptyArray a)
```

Group equal elements of an array into arrays.

```purescript
groupAll [1, 1, 2, 2, 1] == [NonEmptyArray [1, 1, 1], NonEmptyArray [2, 2]]
```

#### `groupBy`

``` purescript
groupBy :: forall a. (a -> a -> Boolean) -> Array a -> Array (NonEmptyArray a)
```

Group equal, consecutive elements of an array into arrays, using the
specified equivalence relation to determine equality.

```purescript
groupBy (\a b -> odd a && odd b) [1, 3, 2, 4, 3, 3]
   = [NonEmptyArray [1, 3], NonEmptyArray [2], NonEmptyArray [4], NonEmptyArray [3, 3]]
```


#### `groupAllBy`

``` purescript
groupAllBy :: forall a. (a -> a -> Ordering) -> Array a -> Array (NonEmptyArray a)
```

Group equal elements of an array into arrays, using the specified
comparison function to determine equality.

```purescript
groupAllBy (comparing Down) [1, 3, 2, 4, 3, 3]
   = [NonEmptyArray [4], NonEmptyArray [3, 3, 3], NonEmptyArray [2], NonEmptyArray [1]]
```


#### `nub`

``` purescript
nub :: forall a. Ord a => Array a -> Array a
```

Remove the duplicates from an array, creating a new array.

```purescript
nub [1, 2, 1, 3, 3] = [1, 2, 3]
```


#### `nubEq`

``` purescript
nubEq :: forall a. Eq a => Array a -> Array a
```

Remove the duplicates from an array, creating a new array.

This less efficient version of `nub` only requires an `Eq` instance.

```purescript
nubEq [1, 2, 1, 3, 3] = [1, 2, 3]
```


#### `nubBy`

``` purescript
nubBy :: forall a. (a -> a -> Ordering) -> Array a -> Array a
```

Remove the duplicates from an array, where element equality is determined
by the specified ordering, creating a new array.

```purescript
nubBy compare [1, 3, 4, 2, 2, 1] == [1, 3, 4, 2]
```


#### `nubByEq`

``` purescript
nubByEq :: forall a. (a -> a -> Boolean) -> Array a -> Array a
```

Remove the duplicates from an array, where element equality is determined
by the specified equivalence relation, creating a new array.

This less efficient version of `nubBy` only requires an equivalence
relation.

```purescript
mod3eq a b = a `mod` 3 == b `mod` 3
nubByEq mod3eq [1, 3, 4, 5, 6] = [1, 3, 5]
```


#### `union`

``` purescript
union :: forall a. Eq a => Array a -> Array a -> Array a
```

Calculate the union of two arrays. Note that duplicates in the first array
are preserved while duplicates in the second array are removed.

Running time: `O(n^2)`

```purescript
union [1, 2, 1, 1] [3, 3, 3, 4] = [1, 2, 1, 1, 3, 4]
```


#### `unionBy`

``` purescript
unionBy :: forall a. (a -> a -> Boolean) -> Array a -> Array a -> Array a
```

Calculate the union of two arrays, using the specified function to
determine equality of elements. Note that duplicates in the first array
are preserved while duplicates in the second array are removed.

```purescript
mod3eq a b = a `mod` 3 == b `mod` 3
unionBy mod3eq [1, 5, 1, 2] [3, 4, 3, 3] = [1, 5, 1, 2, 3]
```


#### `delete`

``` purescript
delete :: forall a. Eq a => a -> Array a -> Array a
```

Delete the first element of an array which is equal to the specified value,
creating a new array.

```purescript
delete 7 [1, 7, 3, 7] = [1, 3, 7]
delete 7 [1, 2, 3] = [1, 2, 3]
```

Running time: `O(n)`

#### `deleteBy`

``` purescript
deleteBy :: forall a. (a -> a -> Boolean) -> a -> Array a -> Array a
```

Delete the first element of an array which matches the specified value,
under the equivalence relation provided in the first argument, creating a
new array.

```purescript
mod3eq a b = a `mod` 3 == b `mod` 3
deleteBy mod3eq 6 [1, 3, 4, 3] = [1, 4, 3]
```


#### `(\\)`

``` purescript
infix 5 difference as \\
```

#### `difference`

``` purescript
difference :: forall a. Eq a => Array a -> Array a -> Array a
```

Delete the first occurrence of each element in the second array from the
first array, creating a new array.

```purescript
difference [2, 1] [2, 3] = [1]
```

Running time: `O(n*m)`, where n is the length of the first array, and m is
the length of the second.

#### `intersect`

``` purescript
intersect :: forall a. Eq a => Array a -> Array a -> Array a
```

Calculate the intersection of two arrays, creating a new array. Note that
duplicates in the first array are preserved while duplicates in the second
array are removed.

```purescript
intersect [1, 1, 2] [2, 2, 1] = [1, 1, 2]
```


#### `intersectBy`

``` purescript
intersectBy :: forall a. (a -> a -> Boolean) -> Array a -> Array a -> Array a
```

Calculate the intersection of two arrays, using the specified equivalence
relation to compare elements, creating a new array. Note that duplicates
in the first array are preserved while duplicates in the second array are
removed.

```purescript
mod3eq a b = a `mod` 3 == b `mod` 3
intersectBy mod3eq [1, 2, 3] [4, 6, 7] = [1, 3]
```


#### `zipWith`

``` purescript
zipWith :: forall a b c. (a -> b -> c) -> Array a -> Array b -> Array c
```

Apply a function to pairs of elements at the same index in two arrays,
collecting the results in a new array.

If one array is longer, elements will be discarded from the longer array.

For example

```purescript
zipWith (*) [1, 2, 3] [4, 5, 6, 7] == [4, 10, 18]
```

#### `zipWithA`

``` purescript
zipWithA :: forall m a b c. Applicative m => (a -> b -> m c) -> Array a -> Array b -> m (Array c)
```

A generalization of `zipWith` which accumulates results in some
`Applicative` functor.

```purescript
sndChars = zipWithA (\a b -> charAt 2 (a <> b))
sndChars ["a", "b"] ["A", "B"] = Nothing -- since "aA" has no 3rd char
sndChars ["aa", "b"] ["AA", "BBB"] = Just ['A', 'B']
```


#### `zip`

``` purescript
zip :: forall a b. Array a -> Array b -> Array (Tuple a b)
```

Takes two arrays and returns an array of corresponding pairs.
If one input array is short, excess elements of the longer array are
discarded.

```purescript
zip [1, 2, 3] ["a", "b"] = [Tuple 1 "a", Tuple 2 "b"]
```


#### `unzip`

``` purescript
unzip :: forall a b. Array (Tuple a b) -> Tuple (Array a) (Array b)
```

Transforms an array of pairs into an array of first components and an
array of second components.

```purescript
unzip [Tuple 1 "a", Tuple 2 "b"] = Tuple [1, 2] ["a", "b"]
```


#### `any`

``` purescript
any :: forall a. (a -> Boolean) -> Array a -> Boolean
```

Returns true if at least one array element satisfies the given predicate,
iterating the array only as necessary and stopping as soon as the predicate
yields true.

```purescript
any (_ > 0) [] = False
any (_ > 0) [-1, 0, 1] = True
any (_ > 0) [-1, -2, -3] = False
```

#### `all`

``` purescript
all :: forall a. (a -> Boolean) -> Array a -> Boolean
```

Returns true if all the array elements satisfy the given predicate.
iterating the array only as necessary and stopping as soon as the predicate
yields false.

```purescript
all (_ > 0) [] = True
all (_ > 0) [1, 2, 3] = True
all (_ > 0) [-1, -2, -3] = False
```

#### `foldM`

``` purescript
foldM :: forall m a b. Monad m => (b -> a -> m b) -> b -> Array a -> m b
```

Perform a fold using a monadic step function.

```purescript
foldM (\x y -> Just (x + y)) 0 [1, 4] = Just 5
```

#### `foldRecM`

``` purescript
foldRecM :: forall m a b. MonadRec m => (b -> a -> m b) -> b -> Array a -> m b
```

#### `unsafeIndex`

``` purescript
unsafeIndex :: forall a. Partial => Array a -> Int -> a
```

Find the element of an array at the specified index.

```purescript
unsafePartial $ unsafeIndex ["a", "b", "c"] 1 = "b"
```

Using `unsafeIndex` with an out-of-range index will not immediately raise a runtime error.
Instead, the result will be undefined. Most attempts to subsequently use the result will
cause a runtime error, of course, but this is not guaranteed, and is dependent on the backend;
some programs will continue to run as if nothing is wrong. For example, in the JavaScript backend,
the expression `unsafePartial (unsafeIndex [true] 1)` has type `Boolean`;
since this expression evaluates to `undefined`, attempting to use it in an `if` statement will cause
the else branch to be taken.


