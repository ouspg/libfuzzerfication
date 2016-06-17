{-# LANGUAGE ForeignFunctionInterface #-}

module Test where

import Foreign.C.Types
import Foreign.C.String

-- extern "C" int LLVMFuzzerTestOneInput(uint8_t *data, size_t size)
foreign export ccall "LLVMFuzzerTestOneInput" testOneInput :: CString -> CSize -> IO CInt

testOneInput :: CString -> CSize -> IO CInt
testOneInput str size = do
  putStrLn "Hello from Haskell!"
  return 0
