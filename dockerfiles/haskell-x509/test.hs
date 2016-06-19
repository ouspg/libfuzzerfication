{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Strict #-}

module Test where

import Foreign.C.Types
import Foreign.C.String
import qualified Data.ByteString as BS

import Control.Monad
import Control.Exception
import qualified Data.X509 as X509

import Data.Byteable (toBytes)
import System.IO
import System.Directory (createDirectoryIfMissing, doesFileExist)
import Crypto.Hash.SHA1 (hash)
import qualified Data.ByteString.Char8 as Char8
import qualified Data.ByteArray.Encoding as BA

-- extern "C" int LLVMFuzzerTestOneInput(uint8_t *data, size_t size)
foreign export ccall "LLVMFuzzerTestOneInput" testOneInputM :: CString -> CSize -> IO CInt

hashInHex :: String -> String
hashInHex = hashInHexBS . Char8.pack

hashInHexBS :: BS.ByteString -> String
hashInHexBS =  Char8.unpack . BA.convertToBase BA.Base16 . toBytes . hash

storeTestCase :: String -> BS.ByteString -> IO ()
storeTestCase name content =
  -- Use first 60 bytes for generating directory name.  This adds
  -- different variants of almost same exception into same directory
  let dir = "results/" ++ hashInHex (take 60 name)
      file = hashInHexBS content
  in do
    createDirectoryIfMissing True dir
    hasReadme <- doesFileExist $ dir ++ "/00README"
    unless hasReadme (
      withFile (dir ++ "/00README") WriteMode $ \h ->
          BS.hPut h $ Char8.pack (name ++ "\n")
      )
    withFile (dir ++ "/" ++ file) WriteMode $ \h ->
      BS.hPut h content

decode :: BS.ByteString -> IO (Either SomeException (Either String X509.SignedCertificate))
decode = try . evaluate . X509.decodeSignedCertificate

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
