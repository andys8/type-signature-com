module FunctionsSpec where

import Prelude

import Data.Array as A
import Data.Either (Either(..), either, isLeft)
import Data.Foldable (for_)
import Data.Newtype (un)
import Data.Set (fromFoldable) as Set
import Data.Set.NonEmpty as NES
import Data.String (contains) as S
import Data.String.Pattern (Pattern(..))
import Data.String.Regex (regex, test)
import Data.String.Regex.Flags (noFlags)
import Effect.Class (liftEffect)
import Effect.Exception (throw)
import Functions (Fun(..), parseFunctions)
import Test.Spec (Spec, before, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldNotEqual, shouldNotSatisfy, shouldSatisfy)

foreign import elmCore :: String
foreign import haskellFunctions :: String
foreign import purescriptFunctions :: String

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
          `shouldEqual` Right (NES.cons f1 $ Set.fromFoldable [ f2 ])

      it "filters duplicates (set)" do
        parseFunctions (f1Text <> "\n" <> f1Text)
          `shouldEqual` Right (NES.singleton f1)

      it "partially invalid data" do
        parseFunctions (f1Text <> "\nwrong")
          `shouldEqual` Left "Couldn't parse line: [\"wrong\"]"

      before (pure $ parseToList haskellFunctions) do
        describe "Haskell" do

          it "can be parsed" \functions -> do
            functions `shouldNotSatisfy` A.null

          it "has no forall" \functions -> do
            -- Explicit foralls are expected to be removed
            let hasForall = S.contains (Pattern "forall")
            let signatures = (_.signature <<< un Fun) <$> functions
            for_ signatures (_ `shouldNotSatisfy` hasForall)

          it "name should be valid" \functions -> do
            let names = (_.name <<< un Fun) <$> functions
            case regex "^[a-zA-Z0-9'_]+|\\(.*\\)$" noFlags of
              Left e -> liftEffect $ throw e
              Right reg -> for_ names (_ `shouldSatisfy` test reg)

      before (pure $ parseToList purescriptFunctions) do
        describe "PureScript" do

          it "can be parsed" \functions -> do
            functions `shouldNotSatisfy` A.null

          it "has no forall" \functions -> do
            -- Explicit foralls are expected to be removed
            let hasForall = S.contains (Pattern "forall")
            let signatures = (_.signature <<< un Fun) <$> functions
            for_ signatures (_ `shouldNotSatisfy` hasForall)

          it "has no single a (missing constraint)" \functions -> do
            -- "one :: a" was a bug
            let signatures = (_.signature <<< un Fun) <$> functions
            for_ signatures (_ `shouldNotEqual` "a")

          it "name should be valid" \functions -> do
            let names = (_.name <<< un Fun) <$> functions
            case regex "^[a-zA-Z0-9'_]+|\\(.*\\)$" noFlags of
              Left e -> liftEffect $ throw e
              Right reg -> for_ names (_ `shouldSatisfy` test reg)

      before (pure $ parseToList elmCore) do
        describe "Elm" do

          it "can be parsed" \functions -> do
            functions `shouldNotSatisfy` A.null

          it "doesn't contain module prefixed types" \functions -> do
            let signatures = (_.signature <<< un Fun) <$> functions
            case regex "[A-Z].*\\.[A-Z]" noFlags of
              Left e -> liftEffect $ throw e
              Right reg -> for_ signatures (_ `shouldNotSatisfy` test reg)

          it "name should be valid" \functions -> do
            let names = (_.name <<< un Fun) <$> functions
            case regex "^[a-zA-Z0-9'_]+|\\(.*\\)$" noFlags of
              Left e -> liftEffect $ throw e
              Right reg -> for_ names (_ `shouldSatisfy` test reg)

parseToList :: String -> Array Fun
parseToList = either (pure []) NES.toUnfoldable <<< parseFunctions

f1Text :: String
f1Text = "f1 :: a -> a"

f1 :: Fun
f1 = Fun { name: "f1", signature: "a -> a" }

f2Text :: String
f2Text = "f2 :: b -> b"

f2 :: Fun
f2 = Fun { name: "f2", signature: "b -> b" }
