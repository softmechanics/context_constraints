{-# LANGUAGE FlexibleInstances, OverlappingInstances, MultiParamTypeClasses, FlexibleContexts, ContextConstraints #-}

class A a where {}
class B a where {}

instance A Char
instance B ()

class Test1 a b where 
  test1 :: a -> b -> [Char]

instance (A a, A b) => Test1 a b where
  test1 _ _ = "A A"

instance (A a, B b) => Test1 a b where
  test1 _ _ = "A B"

instance (B a, B b) => Test1 a b where
  test1 _ _ = "B B"

instance (B a, A b) => Test1 a b where
  test1 _ _ = "B A"

instance Test1 a b where
  test1 _ _ = "Default"

f :: (Test1 Char a) => a -> [Char]
f = test1 'c'

g :: (Test1 () a) => a -> [Char]
g = test1 ()

main = do print $ f 'a'
          print $ f ()
          print $ f 0
          print $ g 'a'
          print $ g ()
          print $ g 0

{- OUTPUT
"A A"
"A B"
"Default"
"B A"
"B B"
"Default"
-}
