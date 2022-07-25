module QuestionsSpec where

import Prelude

import Data.Array (all, intersect, replicate)
import Data.Array as A
import Data.Array.NonEmpty as NEA
import Data.Either (Either(..), fromRight)
import Data.Function (on)
import Data.Newtype (un)
import Data.Set as S
import Data.Set.NonEmpty (NonEmptySet)
import Data.Set.NonEmpty as NES
import Data.Traversable (sequence)
import Effect.Class (class MonadEffect, liftEffect)
import Functions (Fun(..))
import Questions (Question, mkQuestions, toOptions)
import Test.Spec (Spec, before, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldSatisfy)

spec :: Spec Unit
spec =
  describe "Questions" do
    describe "mkQuestions" do

      it "can't create questions if not enough functions for all options (q*4)" do
        questions <- liftEffect $ mkQuestions 3 functions
        questions `shouldEqual` Left "Could not create 4 options"

      it "number of questions can't be 0" do
        questions <- liftEffect $ mkQuestions 0 functions
        questions `shouldEqual` Left "numQuestions <= 0"

      before (mkSingleQuestions 100 functionsDupl) do
        describe "uniqueness" do

          it "correct amount" \qs -> do
            A.length qs `shouldEqual` 100

          it "names are unique" \qs -> do
            all hasUniqueNames qs `shouldEqual` true

          it "signatures are unique" \qs -> do
            all hasUniqueSignatures qs `shouldEqual` true

          it "not all games are the same" \qs -> do
            A.length (A.nub qs) `shouldSatisfy` (_ > 1)

      before (mkQuestions 2 functions) do
        describe "2 valid questions" do
          it "options of question different" \questions -> do
            let options = (toOptions <<< NEA.head) <$> questions
            options `shouldEqual` (A.nub <$> options)

          it "options in questions are different" \questions -> do
            let
              intersection = do
                q1 <- NEA.head <$> questions
                q2 <- NEA.last <$> questions
                pure $ (intersect `on` toOptions) q1 q2
            intersection `shouldEqual` pure []

          it "creates 2 questions" \questions -> do
            (NEA.length <$> questions) `shouldEqual` Right 2

      before (mkSingleQuestions 1000 functionsMath) do
        describe "Number vs. Ord vs. Int" do

          it "names are unique" \qs -> do
            all hasUniqueNames qs `shouldEqual` true

          it "signatures are unique" \qs -> do
            all hasUniqueSignatures qs `shouldEqual` true

          it "has expected result" \qs -> do
            -- Because math functions are similar, the result can only contain 1
            let toNames = A.sort <<< map (_.name <<< un Fun) <<< toOptions
            let isExpected x = A.take 3 (toNames x) == [ "f1", "f2", "f3" ]
            all isExpected qs `shouldEqual` true

-- helper

functions :: NonEmptySet Fun
functions =
  NES.cons (mkFun "f1" "a1 -> b")
    $ S.fromFoldable
        [ mkFun "f2" "a2 -> b"
        , mkFun "f3" "a3 -> b"
        , mkFun "f4" "a4 -> b"
        , mkFun "f5" "a5 -> b"
        , mkFun "f6" "a6 -> b"
        , mkFun "f7" "a7 -> b"
        , mkFun "f8" "a8 -> b"
        , mkFun "f9" "a9 -> b"
        ]

functionsDupl :: NonEmptySet Fun
functionsDupl =
  NES.cons (mkFun "f1" "a1 -> b")
    $ S.fromFoldable
        [ mkFun "f2" "a2 -> b"
        , mkFun "f3" "a3 -> b"
        , mkFun "f4" "a4 -> b"
        -- Same name as f4, but different signature
        , mkFun "f4" "a4dupl -> b"
        -- Same name as f1, but different same
        , mkFun "f1dupl" "a1 -> b"
        ]

functionsMath :: NonEmptySet Fun
functionsMath =
  NES.cons (mkFun "f1" "a1 -> b")
    $ S.fromFoldable
        [ mkFun "f2" "a2 -> b"
        , mkFun "f3" "a3 -> b"
        , mkFun "min" "Number -> Number -> Number"
        , mkFun "max" "Number -> Number -> Number"
        , mkFun "min" "Int -> Int -> Int"
        , mkFun "max" "Int -> Int -> Int"
        , mkFun "min" "Ord a => a -> a -> a"
        , mkFun "max" "Ord a => a -> a -> a"
        , mkFun "mod" "Integral a => a -> a -> a"
        ]

mkFun :: String -> String -> Fun
mkFun name signature = Fun { name, signature }

hasUniqueNames :: Question -> Boolean
hasUniqueNames q = A.nub names == names
  where
  names = (_.name <<< un Fun) <$> toOptions q

hasUniqueSignatures :: Question -> Boolean
hasUniqueSignatures q = A.nub signatures == signatures
  where
  signatures = (_.signature <<< un Fun) <$> toOptions q

mkSingleQuestions :: forall m. MonadEffect m => Int -> NonEmptySet Fun -> m (Array Question)
mkSingleQuestions n fs = do
  let mkSingleQuestion = liftEffect $ mkQuestions 1 fs
  questions <- sequence $ replicate n mkSingleQuestion
  pure $ fromRight [] (A.concatMap NEA.toArray <$> sequence questions)
