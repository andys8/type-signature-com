module Languages where

import Prelude

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Bounded.Generic (genericBottom, genericTop)
import Data.Enum (class BoundedEnum, class Enum, enumFromTo)
import Data.Enum.Generic (genericCardinality, genericFromEnum, genericPred, genericSucc, genericToEnum)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import React.Icons.Gi (giMagnifyingGlass)
import React.Icons.Si (siElm, siHaskell, siPurescript)
import React.Icons.Types (ReactIcon)

data Language = Haskell | PureScript | Elm | HaskellLens

type AllFunctions a =
  { haskell :: a
  , haskellLens :: a
  , purescript :: a
  , elm :: a
  }

derive instance Generic Language _
derive instance Eq Language
instance Show Language where
  show = genericShow

derive instance Ord Language

instance Bounded Language where
  bottom = genericBottom
  top = genericTop

instance BoundedEnum Language where
  cardinality = genericCardinality
  toEnum = genericToEnum
  fromEnum = genericFromEnum

instance Enum Language where
  succ = genericSucc
  pred = genericPred

languages :: NonEmptyArray Language
languages = enumFromTo bottom top

languageIcon :: Language -> ReactIcon
languageIcon Haskell = siHaskell
languageIcon HaskellLens = giMagnifyingGlass
languageIcon PureScript = siPurescript
languageIcon Elm = siElm
