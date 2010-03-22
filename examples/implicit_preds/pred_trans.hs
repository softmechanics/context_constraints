{-# LANGUAGE FlexibleInstances, UndecidableInstances, ContextConstraints #-}

{-
Tests the transitivity of predicates in the context.
-}

class A a where {}
class B a where {}

instance B a => A a
instance B Char

class Test a where
  test :: a -> [Char]

instance (A a) => Test a where
  test _ = "A"

instance Test a where 
  test _ = "Default"

main = do print $ test 'c'
          print $ test ()

{- OUTPUT
"A"
"Default"
-}
