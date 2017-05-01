--  Main.hs
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

module Main where

import           Data.Maybe
import           Directories
import           Downloader
import           FindInString
import           WistiaJSON
import           WTVideo

main :: IO ()
main = do
    base <- fmap (wtURL . fromJust) wtVideos
    lessons <- fmap (wtLessons . fromJust) wtVideos
    mapM_ makeLessonFolder lessons
    let elems = concatMap (constructLessons base) lessons
    let refs = map wistiaRef elems
    wis <- loadRefs refs
    let eachVideo = map (getURLFromJSON . parseWistia) wis
    let updatedRefs = updateListWistiaRef elems eachVideo
    traverse downloadFile updatedRefs
    return ()
