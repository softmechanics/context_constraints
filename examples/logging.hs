{-# LANGUAGE RankNTypes, FlexibleInstances, UndecidableInstances, ContextConstraints  #-}

data E = E
  deriving (Show)
data W = W
  deriving (Show)
data I = I
  deriving (Show)
data D = D
  deriving (Show)

class Error a
class Warn a
class Info a
class Debug a

instance (Error a) => Warn a
instance (Warn a) => Info a
instance (Info a) => Debug a

instance Error E
instance Warn W
instance Info I
instance Debug D

class LogError a where
  logError :: a -> IO ()

instance LogError a where
  logError a = return ()
  
instance (Error a, Show a) => LogError a where
  logError a = putStrLn $ "Error: " ++ (show a)

class LogWarn a where
  logWarn :: a -> IO ()
  
instance LogWarn a where
  logWarn a = return ()
  
instance (Warn a, Show a) => LogWarn a where
  logWarn a = putStrLn $ "Warn: " ++ (show a)

class LogInfo a where
  logInfo :: a -> IO ()
instance LogInfo a where
  logInfo a = return ()

instance (Info a, Show a) => LogInfo a where
  logInfo a = putStrLn $ "Info: " ++ (show a)

class LogDebug a where
  logDebug :: a -> IO ()
instance LogDebug a where
  logDebug a = return ()
  
instance (Debug a, Show a) => LogDebug a where
  logDebug a = putStrLn $ "Debug: " ++ (show a)

main = do logError E
          logError W
          logError I
          logError D

          logWarn E
          logWarn W
          logWarn I
          logWarn D

          logInfo E
          logInfo W
          logInfo I
          logInfo D

          logDebug E
          logDebug W
          logDebug I
          logDebug D

        
{- OUTPUT
Error: E
Warn: E
Warn: W
Info: E
Info: W
Info: I
Debug: E
Debug: W
Debug: I
Debug: D
-}
