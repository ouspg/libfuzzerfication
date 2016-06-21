{-# LANGUAGE ForeignFunctionInterface #-}

module Test where

import Foreign.C.Types
import Foreign.C.String

import qualified Data.ByteString as BS

-- extern "C" int LLVMFuzzerTestOneInput(uint8_t *data, size_t size)
foreign export ccall "LLVMFuzzerTestOneInput" testOneInputM :: CString -> CSize -> IO CInt

testOneInputM :: CString -> CSize -> IO CInt
testOneInputM str size = do
  bs <- BS.packCStringLen (str, fromIntegral size)
  print $ BS.length bs
  return 0 -- Non-zero return values are reserved for future use.
