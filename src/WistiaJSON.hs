--  WistiaJSON.hs
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

module WistiaJSON
    ( module WistiaJSON
    ) where

import           Control.Applicative        ((<$>), (<*>))
import           Control.Lens
import           Data.Aeson                 (FromJSON (..), Value (..), decode,
                                             withObject, (.:), (.:?))
import           Data.Aeson.Lens
import qualified Data.ByteString.Lazy.Char8 as L8
import           Data.Maybe
import           Data.Text

readJSONWistia :: IO L8.ByteString
readJSONWistia = L8.readFile "Wistia.json"

getURLFromJSON :: L8.ByteString -> Maybe Text
getURLFromJSON str = str ^? key "assets" . nth 0 . key "url" . _String
