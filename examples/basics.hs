{-# LANGUAGE FlexibleInstances, UndecidableInstances, EmptyDataDecls, ContextConstraints #-}

class A a where {}
class B a where {}

instance A Char
instance B ()

data Both
instance A Both
instance B Both

class Test a where 
  test :: a -> [Char]

instance (A a) => Test a where
  test _ = "A"

instance (B a) => Test a where
  test _ = "B"

-- deemed more specific than either of above, since their contexts are proper subsets
-- of this context
instance (A a, B a) => Test a where
  test _ = "A+B"

instance Test a where
  test _ = "Neither"

main = do print $ test 'a'
          print $ test ()
          print $ test (undefined::Both)
          print $ test 4

{- OUTPUT
"A"
"B"
"A+B"
"Neither"
-}
