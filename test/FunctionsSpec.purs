module FunctionsSpec where

import Prelude

import Data.Either (Either(..), isLeft)
import Data.Set as S
import Functions (Fun(..), parseFunctions)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldSatisfy)

spec :: Spec Unit
spec =
  describe "Functions" do
    describe "parseFunctions" do
      it "empty" do
        parseFunctions ""
          `shouldSatisfy` isLeft

      it "single example" do
        parseFunctions f1Text
          `shouldEqual` Right (S.singleton f1)

      it "multiple examples" do
        parseFunctions (f1Text <> "\n" <> f2Text)
          `shouldEqual` Right (S.fromFoldable [ f1, f2 ])

      it "filters duplicates (set)" do
        parseFunctions (f1Text <> "\n" <> f1Text)
          `shouldEqual` Right (S.singleton f1)

      it "partially invalid data" do
        parseFunctions (f1Text <> "\nwrong")
          `shouldEqual` Left "Couldn't parse line: [\"wrong\"]"

f1Text :: String
f1Text = "f1 :: a -> a"

f1 :: Fun
f1 = Fun { name: "f1", signature: "a -> a" }

f2Text :: String
f2Text = "f2 :: b -> b"

f2 :: Fun
f2 = Fun { name: "f2", signature: "b -> b" }
