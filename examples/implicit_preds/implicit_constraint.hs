{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances, MultiParamTypeClasses, EmptyDataDecls, ContextConstraints #-}

class A a where {}

instance A Char
instance (Num a) => A a

class Outer a where 
  outer :: a -> [Char]

class Inner a where
  inner :: a -> [Char]

instance A a => Outer a where
  outer a = "A, " ++ (inner a)

instance Outer a where
  outer a = "Default, " ++ (inner a)

instance (A a) => Inner a where
  inner _ = "A" 


-- trying to select Inner Num, which is implied
-- by instace of A for 5.

-- doesn't match without (Num a, A a) => Outer a
-- or Inner a in context of all Outer instances.
-- on the bright side, we can add these instances
-- at any time.  On the dark side, choosing the
-- wrong instance (in terms of what the programmer
-- intended) is REALLY BAD.  

-- Outer is matched by  (Num a) => A a, so we know
-- Num a holds at some point. Need some way to track
-- that, so we can check it when looking up Inner

-- But we can't simply add the preds of any available
-- instance to avails, since in general the implication
-- is reversed.  Preds of an avail instance are resolved
-- after the instance is made avail, whereas we need before.

-- In general, the best approach is to put Inner in the
-- context of Outer whenever it's used (or to override an
-- instance that uses it).  

-- How can we enforce that in the compiler?

instance (Num a, A a) => Inner a where
  inner _ = "Num"

instance Inner a where
  inner _ = "Default"

main = do print $ outer 'a'
          print $ outer 5


{- OUTPUT
"A, A"
"A, A"
-}

