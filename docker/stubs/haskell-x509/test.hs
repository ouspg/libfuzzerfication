{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Strict #-}

module Test where

import Foreign.C.Types
import Foreign.C.String
import qualified Data.ByteString as BS

import Libfuzzer
import Control.Exception (SomeException, try, evaluate)

import qualified Data.X509 as X509

decode :: BS.ByteString -> IO (Either SomeException (Either String X509.SignedCertificate))
decode = try . evaluate . X509.decodeSignedCertificate

foreign export ccall "LLVMFuzzerTestOneInput" testOneInputM :: CString -> CSize -> IO CInt

testOneInputM :: CString -> CSize -> IO CInt
testOneInputM str size = do
  bs <- BS.packCStringLen (str, fromIntegral size)

  result <- decode bs
  case result of
    Right _  -> return ()
    Left err -> do
      let err' = show err
      putStrLn $ "Exception: " ++ err'
      storeTestCase err' bs

  return 0 -- Non-zero return values are reserved for future use.
