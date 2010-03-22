{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances, MultiParamTypeClasses, ContextConstraints #-}

class A a where {}
class B a where {}

instance A Char
instance B ()

class Outer a b where 
  outer :: a -> b -> [Char]

class Inner a b where 
  inner :: a -> b -> [Char]

instance (A a, A b) => Outer a b where
  outer a b = "A A / " ++ inner a b

instance (A a, B b) => Outer a b where
  outer a b = "A B / " ++ inner a b

instance (B a, A b) => Outer a b where
  outer a b = "B A / " ++ inner a b

instance (B a, B b) => Outer a b where
  outer a b = "B B / " ++ inner a b 

instance Outer a b where
  outer a b = "Default / " ++ inner a b


instance (A a, A b) => Inner a b where
  inner a b = "A A" 

instance (A a, B b) => Inner a b where
  inner a b = "A B" 

instance (A a, B b) => Inner b a where
  inner a b = "B A" 

instance (B a, B b) => Inner a b where
  inner a b = "B B" 

instance Inner a b where
  inner a b = "Default" 



class C a where {}
instance C Char

instance (C x, B a, A x) => Outer x a where
  outer a b = "A B+C / " ++ inner a b

instance (C x, B a, A x) => Inner x a where
  inner a b = "A B+C" 

main = do print $ outer a a 
          print $ outer a b 
          print $ outer b a 
          print $ outer b b 
          print $ outer 4 5
       where a = 'a'
             b = ()

{- OUTPUT
"A A / A A"
"A B+C / A B+C"
"B A / B A"
"B B / B B"
"Default / Default"
-}
