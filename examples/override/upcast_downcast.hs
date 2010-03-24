{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances, ContextConstraints #-}

class A a where {}
instance A Char

class Test a where 
  test :: Int -> a -> [Char]


data Upcast a = Upcast a

instance Test a where
  test n a = test n $ Upcast a

instance Test (Upcast a) where
  test 0 _ = ""
  test n (Upcast a) = "Default " ++ (test (n-1) a)

instance (A a) => Test (Upcast a) where
  test 0 _ = ""
  test n (Upcast a) = "A " ++ (test (n-1) a)


class Override a where {}
instance Override a

instance (Override a) => Test a where
  test 0 _ = ""
  test n a = "Override! " ++ (test (n-1) $ Upcast a)

instance (Override a, A a) => Test a where
  test 0 _ = ""
  test n a = "Override A! " ++ (test (n-1) $ Upcast a)


main = do print $ test 5 'c'
          print $ test 6 ()

{- OUTPUT
"Override A! A Override A! A Override A! "
"Override! Default Override! Default Override! Default "
-}

