{-# LANGUAGE EmptyDataDecls, FunctionalDependencies, MultiParamTypeClasses, FlexibleInstances, UndecidableInstances, ContextConstraints #-}

-- Predicates
class A a b | a -> b where {}
class B b where {}
class C b where {}

class Test a where 
  test :: a -> [Char]

instance (A a b, B b) => Test a where
  test _ = "A a b, B b"

instance (A a b, C b) => Test a where
  test _ = "A a b, C b"

data SomeB
instance B SomeB

data SomeC
instance C SomeC

instance A Char SomeB
instance A () SomeC

main = do print $ test 'a'
          print $ test ()

{- OUTPUT
"A a b, B b"
"A a b, C b"
-}
