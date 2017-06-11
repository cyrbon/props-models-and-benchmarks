module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (RunnerEffects, run)

import PropsModelsAndBenchmarks.UnionData (unionDataPropsSpec)
import PropsModelsAndBenchmarks.Variant (variantPropsSpec)

main :: Eff (RunnerEffects ()) Unit
main = run [ consoleReporter ] do
  unionDataPropsSpec
  variantPropsSpec
