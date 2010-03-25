{-# LANGUAGE FlexibleContexts, FlexibleInstances #-}

module Test where

class TestClass a where
  test :: a -> [Char]

instance TestClass a where
  test _ = "Char"
  
testWrap x = print $ test x

-- Adding the context allows testAction2 to use 
-- overridden instances from the caller's scope
testWrap2 :: (TestClass a) => a -> IO ()
testWrap2 x = print $ test x

-- works even for instances not associated with
-- a parameter
testAction = print $ test 'a'

testAction2 :: (TestClass Char) => IO ()
testAction2 = print $ test 'a'

