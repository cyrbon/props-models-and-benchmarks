module PropsModelsAndBenchmarks.UnionData
  ( unionDataPropsBench
  , unionDataPropsSpec
  ) where

import Prelude
import Benchmark
import Type.Equality (class TypeEquals)
import React (ReactElement, ReactClass, createElement)
import Unsafe.Coerce (unsafeCoerce)

import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions.DeepDiff (deepDiffsShouldBeEqual)

import Debug.Trace (spy)
import Control.Monad.Eff (Eff)

-- | Types and Instances
--------------------------------------------------------------------------------

data Left = Left
data Right = Right

data LeftCorner = LeftCorner
data RightCorner = RightCorner


class LeftOrRight a where
  fromLeftOrRight :: a -> String

instance leftPosLeftOrRight :: LeftOrRight Left where
  fromLeftOrRight _ = "left"

instance rightPosLeftOrRight :: LeftOrRight Right where
  fromLeftOrRight _ = "right"

-- | The this instance needs to be passed last. It uses a naming hack for doing
-- | it. PSC evaluates instances in alphabetical order, so we deliberately start
-- | start this instance name with `z`.
-- |
-- | Since, PSC does not currently have class defaults, this hack is the only
-- | way to accomplish this.
instance zzDefaultLeftOrRight :: TypeEquals a Left => LeftOrRight a where
  fromLeftOrRight _ = "left"


class LeftOrRightOrLeftCornerOrRightCorner a where
  fromLeftOrRightOrLeftCornerOrRightCorner :: a -> String

instance zzDefaultfromLeftOrRightOrLeftCornerOrRightCorner
  :: TypeEquals a Left => LeftOrRightOrLeftCornerOrRightCorner a where
  fromLeftOrRightOrLeftCornerOrRightCorner _ = "left"

instance leftPosLeftOrRightOrLeftCornerOrRightCorner
  :: LeftOrRightOrLeftCornerOrRightCorner Left where
  fromLeftOrRightOrLeftCornerOrRightCorner _ = "left"

instance rightPosLeftOrRightOrLeftCornerOrRightCorner
  :: LeftOrRightOrLeftCornerOrRightCorner Right where
  fromLeftOrRightOrLeftCornerOrRightCorner _ = "right"

instance leftCornerLeftOrRightOrLeftCornerOrRightCorner
  :: LeftOrRightOrLeftCornerOrRightCorner LeftCorner where
  fromLeftOrRightOrLeftCornerOrRightCorner _ = "left corner"

instance rightCornerLeftOrRightOrLeftCornerOrRightCorner
  :: LeftOrRightOrLeftCornerOrRightCorner RightCorner where
  fromLeftOrRightOrLeftCornerOrRightCorner _ = "right corner"


type AllInputProps iconPosition labelPosition =
  ( iconPosition :: iconPosition
  , labelPosition :: labelPosition
  )

type AllInputPropsRaw =
  ( iconPosition :: String
  , labelPosition :: String
  )

foreign import data InputProps :: Type
foreign import inputClass :: ReactClass InputProps

-- | A dummy component to show how the resulting API would look
--------------------------------------------------------------------------------

foreign import convertInputProps
  :: forall props defProps iconPosition labelPosition
   . Union props defProps (AllInputProps iconPosition labelPosition)
  => LeftOrRight iconPosition
  => LeftOrRightOrLeftCornerOrRightCorner labelPosition
  => Record props
  -> InputProps

input
  :: forall props defProps iconPosition labelPosition
   . Union props defProps (AllInputProps iconPosition labelPosition)
  => LeftOrRight iconPosition
  => LeftOrRightOrLeftCornerOrRightCorner labelPosition
  => Record props
  -> Array ReactElement
  -> ReactElement
input props children =
  createElement inputClass (unsafeCoerce props) children

exampleUsage :: Array ReactElement
exampleUsage =
  [ input { iconPosition: Right } []
  , input { labelPosition: LeftCorner } []
  ]

-- | Benchmark
--------------------------------------------------------------------------------

-- | This benchmark creates props using `Union` and data.
unionDataPropsBench :: forall s m. SuiteM s _ m (m Unit)
unionDataPropsBench = do
  fn "union data props"
    (\_ -> convertInputProps { iconPosition: Right, labelPosition: LeftCorner })
    (unit)

-- | Test
--------------------------------------------------------------------------------

unionDataPropsSpec :: forall r. Spec r Unit
unionDataPropsSpec =
  describe "union data props" do
    it "should have valid props" $ do
      convertInputProps { iconPosition: Right, labelPosition: LeftCorner }
      `deepDiffsShouldBeEqual`
      { iconPosition: "right", labelPosition: "left corner"}
