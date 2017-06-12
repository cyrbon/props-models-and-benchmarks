module PropsModelsAndBenchmarks.Variant
  ( variantPropsBench
  , variantPropsSpec
  ) where

import Prelude

import Data.Variant as V
import Control.Monad.Eff.Console (log)
import React (ReactElement, ReactClass, createElement)
import Unsafe.Coerce (unsafeCoerce)

import Benchmark

import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions.DeepDiff (deepDiffsShouldBeEqual)

import Debug.Trace (spy)

data Left = Left
data Right = Right

data LeftCorner = LeftCorner
data RightCorner = RightCorner

rightS = V.SProxy ∷ V.SProxy "right"
leftS = V.SProxy ∷ V.SProxy "left"
rightCornerS = V.SProxy ∷ V.SProxy "rightCorner"
leftCornerS = V.SProxy ∷ V.SProxy "leftCorner"

rightCorner = V.inj rightCornerS RightCorner
leftCorner = V.inj leftCornerS LeftCorner
right = V.inj rightS Right
left = V.inj leftS Left

rightToString = V.on rightS (const "right")
leftToString = V.on leftS (const "left")
rightCornerToString = V.on rightCornerS (const "right corner")
leftCornerToString = V.on leftCornerS (const "left corner")

type LeftOrRight = V.Variant (left ∷ Left, right ∷ Right)

type LeftOrRightOrLeftCornerOrRightCorner = V.Variant
  ( left ∷ Left
  , right ∷ Right
  , leftCorner ∷ LeftCorner
  , rightCorner ∷ RightCorner
  )

showLeftOrRight ∷ LeftOrRight → String
showLeftOrRight =
  V.case_
    # rightToString
    # leftToString

showLeftOrRightOrLeftCornerOrRightCorner ∷ LeftOrRightOrLeftCornerOrRightCorner → String
showLeftOrRightOrLeftCornerOrRightCorner =
  V.case_
    # rightToString
    # leftToString
    # rightCornerToString
    # leftCornerToString

type AllInputProps = { iconPosition ∷ LeftOrRight, labelPosition ∷ LeftOrRightOrLeftCornerOrRightCorner }

defaultInputProps ∷ AllInputProps
defaultInputProps = { iconPosition: left, labelPosition: left }

renderInputProps { iconPosition, labelPosition} =
  { iconPosition: showLeftOrRight iconPosition
  , labelPosition: showLeftOrRightOrLeftCornerOrRightCorner labelPosition
  }

foreign import data InputProps :: Type
foreign import inputClass :: ReactClass InputProps

-- | A dummy component to show how the resulting API would look
--------------------------------------------------------------------------------

input :: AllInputProps -> Array ReactElement -> ReactElement
input props children =
  createElement inputClass (unsafeCoerce $ renderInputProps props) children

exampleUsage :: Array ReactElement
exampleUsage =
  [ input (defaultInputProps { iconPosition = right }) []
  , input (defaultInputProps { labelPosition = leftCorner }) []
  ]

-- | Benchmark
--------------------------------------------------------------------------------

-- | This benchmark creates props using the variant library
variantPropsBench :: forall s m. SuiteM s _ m (m Unit)
variantPropsBench = do
  fn "variantProps"
    (\_ -> renderInputProps $ defaultInputProps
      { iconPosition = right, labelPosition = leftCorner }
    )
    (unit)

-- | Test
--------------------------------------------------------------------------------

variantPropsSpec :: forall r. Spec r Unit
variantPropsSpec =
  describe "variant data props" do
    it "should have valid props" $ do
      renderInputProps { iconPosition: right, labelPosition: leftCorner }
      `deepDiffsShouldBeEqual`
      { iconPosition: "right", labelPosition: "left corner"}
