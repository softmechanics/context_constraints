{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances, MultiParamTypeClasses, ContextConstraints #-}

class A a where {}
class B a where {}

instance A Char
instance B ()

class Test2 a b where 
  test2 :: a -> b -> [Char]

instance (A a, A b) => Test2 a b where
  test2 _ _ = "A A"

instance (A a, B b) => Test2 a b where
  test2 a b = "A B (" ++ (test2 a a) ++ ", " ++ (test2 b b) ++ ")"

instance (B a, A b) => Test2 a b where
  test2 a b = "B A (" ++ (test2 a a) ++ ", " ++ (test2 b b) ++ ")"

instance (B a, B b) => Test2 a b where
  test2 _ _ = "B B"

instance Test2 a b where
  test2 _ _ = "Default"

main = do print $ test2 a a 
          print $ test2 a b 
          print $ test2 b a 
          print $ test2 b b 
          print $ test2 4 5
       where a = 'a'
             b = ()

{- OUTPUT
"A A"
"A B (A A, B B)"
"B A (B B, A A)"
"B B"
"Default"
-}

