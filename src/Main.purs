module Main where

import Prelude
import Control.Monad.ST (ST)
import Control.Monad.Eff (Eff)
import Benchmark

import PropsModelsAndBenchmarks.UnionData (unionDataPropsBench)
import PropsModelsAndBenchmarks.Variant (variantPropsBench)

main :: forall s. Eff (st :: ST s) Unit
main = runBench $ do
  unionDataPropsBench
  variantPropsBench
