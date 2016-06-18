{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE Strict #-}

module Test where

import Foreign.C.Types
import Foreign.C.String

import qualified Data.ByteString as BS

import qualified Data.X509 as X509

-- extern "C" int LLVMFuzzerTestOneInput(uint8_t *data, size_t size)
foreign export ccall "LLVMFuzzerTestOneInput" testOneInputM :: CString -> CSize -> IO CInt

testOneInputM :: CString -> CSize -> IO CInt
testOneInputM str size = do
  bs <- BS.packCStringLen (str, fromIntegral size)
  let result = X509.decodeSignedCertificate bs
  return 0 -- Non-zero return values are reserved for future use.
