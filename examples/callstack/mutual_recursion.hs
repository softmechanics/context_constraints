{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances, MultiParamTypeClasses, EmptyDataDecls, ContextConstraints #-}

class A a where {}
class B a where {}

instance A Char
instance B ()

data Both
instance A Both
instance B Both

data AInst
instance A AInst

class IsChar a where {}
instance IsChar Char

class Test2 a where
  test2 :: Int -> a -> [Char]

class Test1 a where 
  test1 :: Int -> a -> [Char]

{- We dont *always* need to declare inner instances in the outer
 - context.  Really unintentional, but might be regarded as a 
 - feature :)
 -}
instance (A a) => Test1 a where
  test1 0 _ = ""
  test1 n a = "Test1 A " ++ (test2 (n-1) a)

instance (B a) => Test1 a where
  test1 0 _ = ""
  test1 n a = "Test1 B " ++ (test2 (n-1) a)

instance (A a, B a) => Test1 a where
  test1 0 _ = ""
  test1 n a = "Test1 A+B " ++ (test2 (n-1) a)

instance (A a, IsChar a) => Test1 a where
  test1 0 _ = ""
  test1 n a = "Test1 Char " ++ (test2 (n-1) a)

instance Test1 a where
  test1 0 _ = ""
  test1 n a = "Test1 Default " ++ (test2 (n-1) a)

instance (A a) => Test2 a where
  test2 0 _ = ""
  test2 n a = "Test2 A " ++ (test1 (n-1) a)

instance (A a, IsChar a) => Test2 a where
  test2 0 _ = ""
  test2 n a = "Test2 Char " ++ (test1 (n-1) a)

instance (B a) => Test2 a where
  test2 0 _ = ""
  test2 n a = "Test2 B "  ++ (test1 (n-1) a)

instance (A a, B a) => Test2 a where
  test2 0 _ = ""
  test2 n a = "Test2 A+B " ++ (test1 (n-1) a)

instance Test2 a where
  test2 0 _ = ""
  test2 n a = "Test2 Default " ++ (test1 (n-1) a)
  
main = do print $ test1 5 'c'
          print $ test1 10 ()
          print $ test1 12 (undefined::AInst)
          print $ test1 7 (undefined::Both)
          print $ test2 9 0

{- OUTPUT
"Test1 Char Test2 Char Test1 Char Test2 Char Test1 Char "
"Test1 B Test2 B Test1 B Test2 B Test1 B Test2 B Test1 B Test2 B Test1 B Test2 B "
"Test1 A Test2 A Test1 A Test2 A Test1 A Test2 A Test1 A Test2 A Test1 A Test2 A Test1 A Test2 A "
"Test1 A+B Test2 A+B Test1 A+B Test2 A+B Test1 A+B Test2 A+B Test1 A+B "
"Test2 Default Test1 Default Test2 Default Test1 Default Test2 Default Test1 Default Test2 Default Test1 Default Test2 Default "
-}

