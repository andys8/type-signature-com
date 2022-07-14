module QuestionsSpec where

import Prelude

import Data.Array (intersect)
import Data.Array as A
import Data.Array.NonEmpty as NEA
import Data.Either (Either(..))
import Data.Function (on)
import Data.Set as S
import Data.Set.NonEmpty (NonEmptySet)
import Data.Set.NonEmpty as NES
import Effect.Class (liftEffect)
import Functions (Fun(..))
import Questions (Question, mkQuestions)
import Test.Spec (Spec, before, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec =
  describe "Functions" do
    describe "mkQuestions" do

      it "can't create questions if not enough functions for all options (q*4)" do
        questions <- liftEffect $ mkQuestions 3 functions
        questions `shouldEqual` Left "Could not create 4 options"

      it "number of questions can't be 0" do
        questions <- liftEffect $ mkQuestions 0 functions
        questions `shouldEqual` Left "numQuestions <= 0"

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

-- helper

functions :: NonEmptySet Fun
functions =
  NES.cons (mkFun "f1") $ S.fromFoldable
    [ mkFun "f2"
    , mkFun "f3"
    , mkFun "f4"
    , mkFun "f5"
    , mkFun "f6"
    , mkFun "f7"
    , mkFun "f8"
    , mkFun "f9"
    ]

mkFun :: String -> Fun
mkFun name = Fun { name, signature: "a -> a" }

toOptions :: Question -> Array Fun
toOptions q =
  [ q.optionA
  , q.optionB
  , q.optionC
  , q.optionD
  ]
