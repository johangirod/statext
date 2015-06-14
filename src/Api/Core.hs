{-# LANGUAGE OverloadedStrings #-}

module Api.Core where

import qualified Data.ByteString.Char8 as B
import Data.Text.Lazy.Encoding
import Data.Aeson

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
analyzeText = readRequestBody 100000000 >>= writeLBS . analyze
	where 
		analyze = encode . take 100 . wordCount . decodeUtf8

apiInit :: SnapletInit b Api
apiInit = makeSnaplet "api" "Core Api" Nothing $ do
        addRoutes apiRoutes
        return Api