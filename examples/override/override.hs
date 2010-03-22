{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances, ContextConstraints #-}

class A a where {}

instance A Char
instance A ()

class Test1 a where 
  test1 :: a -> [Char]

-- little extra boilerplate to retain access to overridden 
-- instances

data (A a) => ToA a = ToA a

instance A a => Test1 a where
  test1 = test1 . ToA 

instance A a => Test1 (ToA a) where
  test1 (ToA _) = "A"

-- The precedence logic allows you to override any instance by defining 
-- a more specific instance (instance with superset context)

class Override a where {}

-- this would override for all As
-- instance A a => Override a

-- just override Char
instance Override Char

instance (Override a, A a) => Test1 a where
  test1 a = "A Override! " ++ (test1 $ ToA a)

main = do print $ test1 'c'
          print $ test1 ()

{- OUTPUT
"A Override! A"
"A"
-}
