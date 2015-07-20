{-# LANGUAGE OverloadedStrings #-}

module Api.Core(apiRoutes) where

import Domain.StatText
import Web.Scotty

import Data.ByteString.Lazy(ByteString)
import Data.Text.Lazy.Encoding
import Data.Text.Lazy(Text, pack)
import Data.Either
import Data.Aeson.Types
import Network.HTTP.Types.Status

import Network.Wai.Parse(FileInfo(..))

import Debug.Trace

import Control.Arrow(left)

type Error = Text



apiRoutes :: ScottyM ()
apiRoutes = do
    analyzeTextRoute
    analyzeFileRoute

getNumberWordParam :: ActionM Int
getNumberWordParam = param "n" `rescue` (\_ -> return 20)

analyzeTextRoute :: ScottyM ()
analyzeTextRoute = post "/api/analyze" $ do
    text <- body
    n <- getNumberWordParam
    json . take n . wordCount . decodeUtf8 $ text

analyzeFileRoute :: ScottyM ()
analyzeFileRoute = post "/api/analyze/file" $ do
    f <- files
    n <- getNumberWordParam
    either (reportError badRequest400) (json . take n . wordCount) (decodeFiles f)

reportError :: Status -> Error -> ActionM ()
reportError s err =  do
    status s
    json . object $ ["error" .= err]

decodeFiles :: [File] -> Either Error Text
decodeFiles [] = Left "No file uploaded"
decodeFiles [x] = decodeFile x
decodeFiles _ = Left "Multiple file upload not supported"


decodeFile :: File -> Either Error Text
decodeFile (_, FileInfo {fileContent=content, fileContentType=contentType})
    | contentType == "text/plain" = decodePlainText $ content
    | otherwise                   = Left "This type of file is not supported"


decodePlainText :: ByteString -> Either Error Text
decodePlainText x = left (pack . show) (decodeUtf8' x)

