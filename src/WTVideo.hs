--  WTVideo.hs
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

{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module WTVideo
    ( module WTVideo
    ) where


import           Control.Applicative        ((<$>), (<*>))
import           Data.Aeson                 (FromJSON (..), Value (..), decode,
                                             (.:), (.:?))
import qualified Data.ByteString.Lazy.Char8 as BS
import           Data.Maybe
import qualified Data.Text                  as T
import           Directories
import           GHC.Generics


data Element = Element {
        name   :: String,
        wistia :: String
} deriving (Show, Generic)


data Lesson = Lesson {
        lesson   :: String,
        elements :: [Element]
} deriving (Show, Generic)

data WTVideo = WTVideo {
        baseURL :: String,
        lessons :: [Lesson]
} deriving (Show, Generic)

instance FromJSON Element
instance FromJSON Lesson
instance FromJSON WTVideo

data WTRef = WTRef {
    lessonRef :: String,
    nameRef   :: String,
    wistiaRef :: String
} deriving (Show)

readJSON :: IO BS.ByteString
readJSON = BS.readFile "VideosToDownload.json"

wtVideos :: IO (Maybe WTVideo)
wtVideos = fmap decode readJSON :: IO (Maybe WTVideo)

wtURL :: WTVideo -> String
wtURL (WTVideo baseURL _) = baseURL

wtLessons :: WTVideo -> [Lesson]
wtLessons (WTVideo _ lesson) = lesson

makeLessonFolder :: Lesson -> IO ()
makeLessonFolder (Lesson lesson _) = createDir lesson

constructWistia :: String -> String -> Element -> WTRef
constructWistia base lessonRef (Element name wistia) = WTRef lessonRef name (base ++ wistia)

constructLessons :: String -> Lesson -> [WTRef]
constructLessons base (Lesson lesson elements) = map (constructWistia base lesson) elements

pathToStoreLesson :: Lesson -> Element -> String
pathToStoreLesson (Lesson lesson _) (Element name _) = dirHome $ lesson ++ "/" ++ name

pairedLesson :: Lesson -> (String, [Element])
pairedLesson (Lesson lesson elements) = (lesson, elements)

updateWistiaRef :: WTRef -> Maybe T.Text -> WTRef
updateWistiaRef (WTRef lessonRef nameRef _ ) text = WTRef lessonRef nameRef link
    where link = T.unpack $ fromJust text

updateListWistiaRef :: [WTRef] -> [Maybe T.Text] -> [WTRef]
updateListWistiaRef = zipWith updateWistiaRef
