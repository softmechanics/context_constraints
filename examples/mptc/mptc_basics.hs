{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances, MultiParamTypeClasses, ContextConstraints #-}

class A a where {}
class B a where {}

instance A Char
instance B ()

class Test a b where 
  test :: a -> b -> [Char]

instance (A a, A b) => Test a b where
  test _ _ = "A A"

instance (A a, B b) => Test a b where
  test a b = "A B (" ++ (test a a) ++ ", " ++ (test b b) ++ ")"

instance (B a, A b) => Test a b where
  test a b = "B A (" ++ (test a a) ++ ", " ++ (test b b) ++ ")"

instance (B a, B b) => Test a b where
  test _ _ = "B B"

instance Test a b where
  test _ _ = "Default"

main = do print $ test a a 
          print $ test a b 
          print $ test b a 
          print $ test b b 
          print $ test 4 5
       where a = 'a'
             b = ()

{- OUTPUT
"A A"
"A B (A A, B B)"
"B A (B B, A A)"
"B B"
"Default"
-}

