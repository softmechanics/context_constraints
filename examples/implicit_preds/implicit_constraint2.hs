{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances, MultiParamTypeClasses, EmptyDataDecls, ContextConstraints #-}

class A a where {}

instance A Char
instance (Num a) => A a

class Outer a where 
  outer :: a -> [Char]

class Inner a where
  inner :: a -> [Char]

instance (A a, Inner a) => Outer a where
  outer a = "A, " ++ (inner a)

instance (Inner a) => Outer a where
  outer a = "Default, " ++ (inner a)

instance (A a) => Inner a where
  inner _ = "A" 

instance (Num a, A a) => Inner a where
  inner _ = "Num"

instance Inner a where
  inner _ = "Default"

main = do print $ outer 'a'
          print $ outer 5


{- OUTPUT
"A, A"
"A, Num"
-}

