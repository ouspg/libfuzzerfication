{-# LANGUAGE ForeignFunctionInterface #-}

module Test where

import Libfuzzer (storeTestCase)

import Foreign.C.Types
import Foreign.C.String

import qualified Data.ByteString as BS

foreign export ccall "LLVMFuzzerTestOneInput" testOneInputM :: CString -> CSize -> IO CInt

testOneInputM :: CString -> CSize -> IO CInt
testOneInputM str size = do
  bs <- BS.packCStringLen (str, fromIntegral size)
  print $ BS.length bs
  return 0 -- Non-zero return values are reserved for future use.
