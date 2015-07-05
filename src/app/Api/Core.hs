{-# LANGUAGE OverloadedStrings #-}

module Api.Core where

import qualified Data.ByteString.Char8 as B
import Data.Text.Lazy.Encoding
import Data.Map.Lazy
import Data.Aeson
import Data.Maybe

import Control.Applicative

import Domain.StatText

import Snap.Snaplet
import Snap.Core


import Debug.Trace
import Control.Monad.IO.Class

data Api = Api

apiRoutes :: [(B.ByteString, Handler b Api ())]
apiRoutes = [("status", method GET respondOk), ("analyze", method POST analyzeText)]

respondOk :: Handler b Api ()
respondOk = modifyResponse $ setResponseCode 200

analyzeText :: Handler b Api ()
analyzeText = do
 	text <- readRequestBody 100000000
 	n <- getsRequest $ fromMaybe 20 . getIntParam "n"
 	writeLBS . analyze n $ text
 	modifyResponse $ (setHeader "Access-Control-Allow-Origin" "*")
		where
		analyze n = encode . take n . wordCount . decodeUtf8

getIntParam :: B.ByteString -> Request -> Maybe Int
getIntParam paramName = (fst <$>) . B.readInt . head . findWithDefault [""] paramName . rqQueryParams

apiInit :: SnapletInit b Api
apiInit = makeSnaplet "api" "Core Api" Nothing $ do
        addRoutes apiRoutes
        return Api