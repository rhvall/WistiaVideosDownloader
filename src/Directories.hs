--  Directories.hs
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

module Directories
    ( createDir, dirHome
    ) where

import           System.Directory

createDir :: String -> IO ()
createDir dir = createDirectoryIfMissing True $ dirHome dir

dirHome :: String -> FilePath
dirHome dir = "Downloaded/" ++ dir
