--  Downloader.hs
--  WTVideos
--
--  Modified by rhvall on 1/May/2017.
--  Copyright (c) 2012 rhvall. All rights reserved.
--
--       (\___/)
--       (o\ /o)
--      /|:.V.:|\
--      \\::::://
--  -----`"" ""`-----

{-# LANGUAGE OverloadedStrings #-}

module Downloader
( module Downloader )
where

import qualified Data.ByteString.Lazy                 as L
import           Directories
import           Network                              (withSocketsDo)
import           Network.HTTP.Client.Conduit.Download as DD
import           Network.HTTP.Simple
import           System.Directory
import           WTVideo

loadWistia :: String -> IO (Response L.ByteString)
loadWistia str = withSocketsDo $ parseRequest str >>= httpLBS

loadRefs :: [String] -> IO [L.ByteString]
loadRefs strs = do
    let resp = map loadWistia strs
    traverse (fmap getResponseBody) resp

downloadFile :: WTRef -> IO ()
downloadFile (WTRef lesson name wistia) = do
    let path = dirHome $ lesson ++ "/" ++ name ++ ".mp4"
    fileExists <- doesFileExist path
    if  fileExists
        then putStrLn $ "File Exists: " ++ path
    else
        DD.download wistia path;
        putStrLn $ "File Downloaded: " ++ path
