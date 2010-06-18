{-# LANGUAGE FlexibleInstances, UndecidableInstances, EmptyDataDecls, ContextConstraints, MultiParamTypeClasses, ScopedTypeVariables, TypeFamilies, FunctionalDependencies #-}

import Prelude hiding ((.))
import qualified Prelude as P
import Control.Monad 
import Data.Monoid
import Data.Maybe
import Control.Applicative


class Compose a b c where
  (.) :: a -> b -> c

instance Compose (b -> c) (a -> b) (a -> c) where
  (.) = (P..)

-- composition of actions
instance (Monad m) => Compose (m a) (m b) (m b) where
  (.) = (>>)

-- composition of actions producing composable functions
instance (Monad m) => Compose (m (b -> c)) (m (a -> b)) (m (a -> c)) where
  f . g = do f' <- f
             g' <- g
             return (f' . g')

instance (Applicative f) => Compose (f (b -> c)) (f (a -> b)) (f (a -> c)) where
  f . g = pure (P..) <*> f <*> g

-- use the applicative instance for instances of both applicative and monad
instance (Applicative f, Monad f) => Compose (f (b -> c)) (f (a -> b)) (f (a -> c)) where
  f . g = pure (P..) <*> f <*> g

-- Control.Category..

compFunc :: Char
compFunc = (head . tail) "hey"

compMonad :: IO ()
compMonad = (putStr "hey") . (putStrLn "!")

compMaybe :: Maybe Char
compMaybe = (Just headChar . Just tailChar) <*> Just "hey"
  where headChar :: [Char] -> Char
        headChar = head
        tailChar :: [Char] -> [Char]
        tailChar = tail

main = do print compFunc
          compMonad
          print compMaybe

{- OUTPUT
'e'
hey!
Just 'e'
-}

