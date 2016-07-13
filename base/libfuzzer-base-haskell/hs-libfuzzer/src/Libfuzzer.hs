{-# LANGUAGE OverloadedStrings #-}

module Libfuzzer
  (
    storeTestCase
  ) where

import Control.Monad (unless)
import Crypto.Hash.SHA1 (hash)
import Data.Byteable (toBytes)
import System.Directory (createDirectoryIfMissing, doesFileExist)
import System.IO (withFile, IOMode(..))

import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as Char8
import qualified Data.ByteArray.Encoding as BA

hashInHex :: String -> String
hashInHex = hashInHexBS . Char8.pack

hashInHexBS :: BS.ByteString -> String
hashInHexBS =  Char8.unpack . BA.convertToBase BA.Base16 . toBytes . hash

storeTestCase :: String -> BS.ByteString -> IO ()
storeTestCase name content =
  -- Use first 60 bytes for generating directory name. This adds
  -- different variants of almost same exception into same directory
  let dir = "results/" ++ hashInHex (take 60 name)
      file = hashInHexBS content
      readme = dir ++ "/00README"
  in do
    createDirectoryIfMissing True dir
    hasReadme <- doesFileExist readme
    unless hasReadme (
      withFile readme WriteMode $ \h ->
          BS.hPut h $ Char8.pack (name ++ "\n")
      )
    withFile (dir ++ "/" ++ file) WriteMode $ \h ->
      BS.hPut h content
