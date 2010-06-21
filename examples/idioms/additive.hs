{-# LANGUAGE FlexibleInstances, UndecidableInstances, EmptyDataDecls, ContextConstraints, MultiParamTypeClasses, ScopedTypeVariables, TypeFamilies, FunctionalDependencies #-}

import Prelude hiding ((+))
import qualified Prelude as P
import Control.Monad 
import Data.Monoid
import Control.Applicative

class Additive a where
  (+) :: a -> a -> a

instance (Num a) => Additive a where
  (+) = (P.+)

instance (Monoid m) => Additive m where
  (+) = mappend

-- Num
i = 1 + 2

-- Monoid
s = "foo " + "bar"

main = do print i
          print s

{- OUTPUT
3
"foo bar"
-}
