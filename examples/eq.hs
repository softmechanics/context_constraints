{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances, ContextConstraints #-}

class Eq2 a b where
  (.==.) :: a -> b -> Bool

instance (Eq a) => Eq2 a a where
  (.==.) = (==)

instance Eq2 a b where
  _ .==. _ = False

main = do print $ 'a' .==. 'a'
          print $ 'a' .==. 'b'
          print $ 'a' .==. ()

{- OUTPUT
True
False
False
-}

