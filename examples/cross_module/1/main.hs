{-# LANGUAGE FlexibleInstances, UndecidableInstances, ContextConstraints #-}

import Test

-- This example shows the potential for library designers to allow
-- users to override internally used instances.  The overridable
-- instances are those in the contexts of exported functions.

class Override a where {}
instance Override a

instance (Override a) => TestClass a where
  test _ = "Override"

main = do testAction
          testAction2
          testWrap 'a'
          testWrap2 'a'

          print $ test 'a'

