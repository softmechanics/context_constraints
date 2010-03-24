{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances, MultiParamTypeClasses, EmptyDataDecls, ContextConstraints #-}

class A a where {}
class B a where {}

instance A Char
instance B ()

data Both
instance A Both
instance B Both

data SomeA
instance A SomeA

class IsChar a where {}
instance IsChar Char

class Inner a where
  inner :: a -> [Char]

class Outer a where 
  outer :: a -> [Char]

{- We dont *always* need to declare inner instances in the outer
 - context.  
 -}
instance (A a) => Outer a where
  outer a = "A, " ++ (inner a)

instance (B a) => Outer a where
  outer a = "B, " ++ (inner a)

instance (A a, B a) => Outer a where
  outer a = "A+B, " ++ (inner a)

instance (A a, IsChar a) => Outer a where
  outer a = "Char, " ++ (inner a)

instance Outer a where
  outer a = "Default, " ++ (inner a)


instance (A a) => Inner a where
  inner _ = "A" 

instance (A a, IsChar a) => Inner a where
  inner _ = "Char"

instance (B a) => Inner a where
  inner _ = "B" 

instance (A a, B a) => Inner a where
  inner _ = "A+B"

instance Inner a where
  inner _ = "Default"

main = do print $ outer a
          print $ outer b
          print $ outer (undefined::SomeA)
          print $ outer both
          print $ outer 5
       where a = 'a'
             b = ()
             both = (undefined::Both)

{- OUTPUT
"Char, Char"
"B, B"
"A, A"
"A+B, A+B"
"Default, Default"
-}

