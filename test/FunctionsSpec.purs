module FunctionsSpec where

import Prelude

import Data.Either (Either(..), isLeft, isRight)
import Data.Set as S
import Data.Set.NonEmpty as NES
import Functions (Fun(..), parseFunctions)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldSatisfy)

foreign import elmCore :: String
foreign import haskellPrelude :: String
foreign import purescriptPrelude :: String

spec :: Spec Unit
spec =
  describe "Functions" do
    describe "parseFunctions" do
      it "empty" do
        parseFunctions ""
          `shouldSatisfy` isLeft

      it "single example" do
        parseFunctions f1Text
          `shouldEqual` Right (NES.singleton f1)

      it "multiple examples" do
        parseFunctions (f1Text <> "\n" <> f2Text)
          `shouldEqual` Right (NES.cons f1 $ S.fromFoldable [ f2 ])

      it "filters duplicates (set)" do
        parseFunctions (f1Text <> "\n" <> f1Text)
          `shouldEqual` Right (NES.singleton f1)

      it "partially invalid data" do
        parseFunctions (f1Text <> "\nwrong")
          `shouldEqual` Left "Couldn't parse line: [\"wrong\"]"

      describe "Haskell" do

        it "can be parsed" do
          parseFunctions haskellPrelude `shouldSatisfy` isRight

      describe "Elm" do

        it "can be parsed" do
          parseFunctions elmCore `shouldSatisfy` isRight

      describe "PureScript" do

        it "can be parsed" do
          parseFunctions purescriptPrelude `shouldSatisfy` isRight

f1Text :: String
f1Text = "f1 :: a -> a"

f1 :: Fun
f1 = Fun { name: "f1", signature: "a -> a" }

f2Text :: String
f2Text = "f2 :: b -> b"

f2 :: Fun
f2 = Fun { name: "f2", signature: "b -> b" }
