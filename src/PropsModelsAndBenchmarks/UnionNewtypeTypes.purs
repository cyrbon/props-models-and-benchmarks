-- | Hides constructors for newtypes. This ensures that values for newtypes are
-- | valid because they can only be created through custom constructors exported
-- | from here.
module PropsModulesAndBenchmarks.UnionNewtypeTypes
  ( Left
  , left
  , Right
  , right
  , LeftCorner
  , leftCorner
  , RightCorner
  , rightCorner
  ) where

newtype Left = MkLeft String
newtype Right = MkRight String

newtype LeftCorner = MkLeftCorner String
newtype RightCorner = MkRightCorner String

left :: Left
left = MkLeft "left"

right :: Right
right = MkRight "right"

leftCorner :: LeftCorner
leftCorner = MkLeftCorner "left corner"

rightCorner :: RightCorner
rightCorner = MkRightCorner "right corner"
