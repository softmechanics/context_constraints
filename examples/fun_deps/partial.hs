{-# LANGUAGE EmptyDataDecls, FunctionalDependencies, MultiParamTypeClasses, FlexibleInstances, FlexibleContexts, UndecidableInstances, ContextConstraints #-}

{- "partial functional dependencies"
 - 
 -}

class Fun1 a b | a -> b where
  fun1 :: a -> b
instance Fun1 In1 Out1 where
  fun1 _ = Out1

class Fun2 a b | b -> a where
  fun2 :: a -> b
instance Fun2 In2 Out2 where
  fun2 _ = Out2

class In a where
  getIn :: a

instance In In1 where
  getIn = In1

instance In In2 where
  getIn = In2

data Out1 = Out1
  deriving Show
data Out2 = Out2
  deriving Show
data Out3 = Out3
  deriving Show
data In1 = In1
  deriving Show
data In2 = In2
  deriving Show
data In3 = In3
  deriving Show

class Test a b where 
  test :: a -> (String, b)

instance (Fun1 a b) => Test a b where
  test x = ("Fun1", fun1 x)

instance (Fun2 a b) => Test a b where
  test x = ("Fun2", fun2 x)

-- this would violate b -> a, since 
instance Test In3 Out1 where
  test x = ("", Out1)

instance Test In3 Out3 where
  test x = ("", Out3)

instance Test In2 Out3 where
  test x = ("", Out3)


-- Out1 is inferred from In1
test1 = test In1

-- In2 is inferred from Out2
test2 :: (String, Out2)
test2 = test getIn

main = do print test1
          print test2

{- OUTPUT
("Fun1",Out1)
("Fun2",Out2)
-}
