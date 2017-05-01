--  FindInString.hs
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

module FindInString
( module FindInString )
where

import qualified Data.ByteString.Lazy    as L
import qualified Data.Text.Lazy          as TL
import qualified Data.Text.Lazy.Encoding as E

firstPart :: TL.Text
firstPart = "Wistia.iframeInit("

lastPart :: TL.Text
lastPart = ", {});\n</script>\n</body>\n</html>\n"

decodeByteStr :: L.ByteString -> TL.Text
decodeByteStr = E.decodeUtf8

encodeByteStr :: TL.Text -> L.ByteString
encodeByteStr = E.encodeUtf8

splitAtFirstPart :: TL.Text -> TL.Text
splitAtFirstPart str = last $ TL.splitOn firstPart str

splitAtLastPart :: TL.Text -> TL.Text
splitAtLastPart str = head $ TL.splitOn lastPart str

parseWistia :: L.ByteString -> L.ByteString
parseWistia = encodeByteStr . splitAtLastPart . splitAtFirstPart . decodeByteStr
