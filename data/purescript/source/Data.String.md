## Module Data.String


### Re-exported from Data.String.CodePoints:

#### `CodePoint`

``` purescript
newtype CodePoint
```

CodePoint is an `Int` bounded between `0` and `0x10FFFF`, corresponding to
Unicode code points.

##### Instances
``` purescript
Eq CodePoint
Ord CodePoint
Show CodePoint
Bounded CodePoint
Enum CodePoint
BoundedEnum CodePoint
```

#### `uncons`

``` purescript
uncons :: String -> Maybe { head :: CodePoint, tail :: String }
```

Returns a record with the first code point and the remaining code points
of the string. Returns `Nothing` if the string is empty. Operates in
constant space and time.

```purescript
>>> uncons "𝐀𝐀 c 𝐀"
Just { head: CodePoint 0x1D400, tail: "𝐀 c 𝐀" }
>>> uncons ""
Nothing
```


#### `toCodePointArray`

``` purescript
toCodePointArray :: String -> Array CodePoint
```

Creates an array of code points from a string. Operates in space and time
linear to the length of the string.

```purescript
>>> codePointArray = toCodePointArray "b 𝐀𝐀"
>>> codePointArray
[CodePoint 0x62, CodePoint 0x20, CodePoint 0x1D400, CodePoint 0x1D400]
>>> map singleton codePointArray
["b", " ", "𝐀", "𝐀"]
```


#### `takeWhile`

``` purescript
takeWhile :: (CodePoint -> Boolean) -> String -> String
```

Returns a string containing the leading sequence of code points which all
match the given predicate from the string. Operates in constant space and
in time linear to the length of the string.

```purescript
>>> takeWhile (\c -> fromEnum c == 0x1D400) "𝐀𝐀 b c 𝐀"
"𝐀𝐀"
```


#### `take`

``` purescript
take :: Int -> String -> String
```

Returns a string containing the given number of code points from the
beginning of the given string. If the string does not have that many code
points, returns the empty string. Operates in constant space and in time
linear to the given number.

```purescript
>>> take 3 "b 𝐀𝐀 c 𝐀"
"b 𝐀"
-- compare to Data.String:
>>> take 3 "b 𝐀𝐀 c 𝐀"
"b �"
```


#### `stripSuffix`

``` purescript
stripSuffix :: Pattern -> String -> Maybe String
```

If the string ends with the given suffix, return the portion of the
string left after removing it, as a `Just` value. Otherwise, return
`Nothing`.

```purescript
stripSuffix (Pattern ".exe") "psc.exe" == Just "psc"
stripSuffix (Pattern ".exe") "psc" == Nothing
```

#### `stripPrefix`

``` purescript
stripPrefix :: Pattern -> String -> Maybe String
```

If the string starts with the given prefix, return the portion of the
string left after removing it, as a `Just` value. Otherwise, return `Nothing`.

```purescript
stripPrefix (Pattern "http:") "http://purescript.org" == Just "//purescript.org"
stripPrefix (Pattern "http:") "https://purescript.org" == Nothing
```

#### `splitAt`

``` purescript
splitAt :: Int -> String -> { after :: String, before :: String }
```

Splits a string into two substrings, where `before` contains the code
points up to (but not including) the given index, and `after` contains the
rest of the string, from that index on.

```purescript
>>> splitAt 3 "b 𝐀𝐀 c 𝐀"
{ before: "b 𝐀", after: "𝐀 c 𝐀" }
```

Thus the length of `(splitAt i s).before` will equal either `i` or
`length s`, if that is shorter. (Or if `i` is negative the length will be
0.)

In code:
```purescript
length (splitAt i s).before == min (max i 0) (length s)
(splitAt i s).before <> (splitAt i s).after == s
splitAt i s == {before: take i s, after: drop i s}
```

#### `singleton`

``` purescript
singleton :: CodePoint -> String
```

Creates a string containing just the given code point. Operates in
constant space and time.

```purescript
>>> map singleton (toEnum 0x1D400)
Just "𝐀"
```


#### `length`

``` purescript
length :: String -> Int
```

Returns the number of code points in the string. Operates in constant
space and in time linear to the length of the string.

```purescript
>>> length "b 𝐀𝐀 c 𝐀"
8
-- compare to Data.String:
>>> length "b 𝐀𝐀 c 𝐀"
11
```


#### `lastIndexOf'`

``` purescript
lastIndexOf' :: Pattern -> Int -> String -> Maybe Int
```

Returns the number of code points preceding the first match of the given
pattern in the string. Pattern matches following the given index will be
ignored.

Giving a negative index is equivalent to giving 0 and giving an index
greater than the number of code points in the string is equivalent to
searching in the whole string.

Returns `Nothing` when no matches are found.

```purescript
>>> lastIndexOf' (Pattern "𝐀") (-1) "b 𝐀𝐀 c 𝐀"
Nothing
>>> lastIndexOf' (Pattern "𝐀") 0 "b 𝐀𝐀 c 𝐀"
Nothing
>>> lastIndexOf' (Pattern "𝐀") 5 "b 𝐀𝐀 c 𝐀"
Just 3
>>> lastIndexOf' (Pattern "𝐀") 8 "b 𝐀𝐀 c 𝐀"
Just 7
>>> lastIndexOf' (Pattern "o") 5 "b 𝐀𝐀 c 𝐀"
Nothing
```


#### `lastIndexOf`

``` purescript
lastIndexOf :: Pattern -> String -> Maybe Int
```

Returns the number of code points preceding the last match of the given
pattern in the string. Returns `Nothing` when no matches are found.

```purescript
>>> lastIndexOf (Pattern "𝐀") "b 𝐀𝐀 c 𝐀"
Just 7
>>> lastIndexOf (Pattern "o") "b 𝐀𝐀 c 𝐀"
Nothing
```


#### `indexOf'`

``` purescript
indexOf' :: Pattern -> Int -> String -> Maybe Int
```

Returns the number of code points preceding the first match of the given
pattern in the string. Pattern matches preceding the given index will be
ignored. Returns `Nothing` when no matches are found.

```purescript
>>> indexOf' (Pattern "𝐀") 4 "b 𝐀𝐀 c 𝐀"
Just 7
>>> indexOf' (Pattern "o") 4 "b 𝐀𝐀 c 𝐀"
Nothing
```


#### `indexOf`

``` purescript
indexOf :: Pattern -> String -> Maybe Int
```

Returns the number of code points preceding the first match of the given
pattern in the string. Returns `Nothing` when no matches are found.

```purescript
>>> indexOf (Pattern "𝐀") "b 𝐀𝐀 c 𝐀"
Just 2
>>> indexOf (Pattern "o") "b 𝐀𝐀 c 𝐀"
Nothing
```


#### `fromCodePointArray`

``` purescript
fromCodePointArray :: Array CodePoint -> String
```

Creates a string from an array of code points. Operates in space and time
linear to the length of the array.

```purescript
>>> codePointArray = toCodePointArray "c 𝐀"
>>> codePointArray
[CodePoint 0x63, CodePoint 0x20, CodePoint 0x1D400]
>>> fromCodePointArray codePointArray
"c 𝐀"
```


#### `dropWhile`

``` purescript
dropWhile :: (CodePoint -> Boolean) -> String -> String
```

Drops the leading sequence of code points which all match the given
predicate from the string. Operates in constant space and in time linear
to the length of the string.

```purescript
>>> dropWhile (\c -> fromEnum c == 0x1D400) "𝐀𝐀 b c 𝐀"
" b c 𝐀"
```


#### `drop`

``` purescript
drop :: Int -> String -> String
```

Drops the given number of code points from the beginning of the string. If
the string does not have that many code points, returns the empty string.
Operates in constant space and in time linear to the given number.

```purescript
>>> drop 5 "𝐀𝐀 b c"
"c"
-- compared to Data.String:
>>> drop 5 "𝐀𝐀 b c"
"b c" -- because "𝐀" occupies 2 code units
```


#### `countPrefix`

``` purescript
countPrefix :: (CodePoint -> Boolean) -> String -> Int
```

Returns the number of code points in the leading sequence of code points
which all match the given predicate. Operates in constant space and in
time linear to the length of the string.

```purescript
>>> countPrefix (\c -> fromEnum c == 0x1D400) "𝐀𝐀 b c 𝐀"
2
```


#### `contains`

``` purescript
contains :: Pattern -> String -> Boolean
```

Checks whether the pattern appears in the given string.

```purescript
contains (Pattern "needle") "haystack with needle" == true
contains (Pattern "needle") "haystack" == false
```

#### `codePointFromChar`

``` purescript
codePointFromChar :: Char -> CodePoint
```

Creates a `CodePoint` from a given `Char`.

```purescript
>>> codePointFromChar 'B'
CodePoint 0x42 -- represents 'B'
```


#### `codePointAt`

``` purescript
codePointAt :: Int -> String -> Maybe CodePoint
```

Returns the first code point of the string after dropping the given number
of code points from the beginning, if there is such a code point. Operates
in constant space and in time linear to the given index.

```purescript
>>> codePointAt 1 "𝐀𝐀𝐀𝐀"
Just (CodePoint 0x1D400) -- represents "𝐀"
-- compare to Data.String:
>>> charAt 1 "𝐀𝐀𝐀𝐀"
Just '�'
```


### Re-exported from Data.String.Common:

#### `trim`

``` purescript
trim :: String -> String
```

Removes whitespace from the beginning and end of a string, including
[whitespace characters](http://www.ecma-international.org/ecma-262/5.1/#sec-7.2)
and [line terminators](http://www.ecma-international.org/ecma-262/5.1/#sec-7.3).

```purescript
trim "   Hello  \n World\n\t    " == "Hello  \n World"
```

#### `toUpper`

``` purescript
toUpper :: String -> String
```

Returns the argument converted to uppercase.

```purescript
toUpper "Hello" == "HELLO"
```

#### `toLower`

``` purescript
toLower :: String -> String
```

Returns the argument converted to lowercase.

```purescript
toLower "hElLo" == "hello"
```

#### `split`

``` purescript
split :: Pattern -> String -> Array String
```

Returns the substrings of the second string separated along occurences
of the first string.

```purescript
split (Pattern " ") "hello world" == ["hello", "world"]
```

#### `replaceAll`

``` purescript
replaceAll :: Pattern -> Replacement -> String -> String
```

Replaces all occurences of the pattern with the replacement string.

```purescript
replaceAll (Pattern "<=") (Replacement "≤") "a <= b <= c" == "a ≤ b ≤ c"
```

#### `replace`

``` purescript
replace :: Pattern -> Replacement -> String -> String
```

Replaces the first occurence of the pattern with the replacement string.

```purescript
replace (Pattern "<=") (Replacement "≤") "a <= b <= c" == "a ≤ b <= c"
```

#### `null`

``` purescript
null :: String -> Boolean
```

Returns `true` if the given string is empty.

```purescript
null "" == true
null "Hi" == false
```

#### `localeCompare`

``` purescript
localeCompare :: String -> String -> Ordering
```

Compare two strings in a locale-aware fashion. This is in contrast to
the `Ord` instance on `String` which treats strings as arrays of code
units:

```purescript
"ä" `localeCompare` "b" == LT
"ä" `compare` "b" == GT
```

#### `joinWith`

``` purescript
joinWith :: String -> Array String -> String
```

Joins the strings in the array together, inserting the first argument
as separator between them.

```purescript
joinWith ", " ["apple", "banana", "orange"] == "apple, banana, orange"
```

### Re-exported from Data.String.Pattern:

#### `Replacement`

``` purescript
newtype Replacement
  = Replacement String
```

A newtype used in cases to specify a replacement for a pattern.

##### Instances
``` purescript
Eq Replacement
Ord Replacement
Newtype Replacement _
Show Replacement
```

#### `Pattern`

``` purescript
newtype Pattern
  = Pattern String
```

A newtype used in cases where there is a string to be matched.

```purescript
pursPattern = Pattern ".purs"
--can be used like this:
contains pursPattern "Test.purs"
   == true
```


##### Instances
``` purescript
Eq Pattern
Ord Pattern
Newtype Pattern _
Show Pattern
```

