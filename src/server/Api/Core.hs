{-# LANGUAGE OverloadedStrings #-}

module Api.Core(apiRoutes) where

import Domain.StatText
import Web.Scotty
import Data.Text.Lazy.Encoding

import Network.HTTP.Types.Status

apiRoutes = do
    analyzeTextRoute
    analyzeFileRoute
    testi

analyzeTextRoute = post "/api/analyze" $ do
    text <- body
    n <- param "n"
    json . take n . wordCount . decodeUtf8 $ text

analyzeFileRoute = post "/api/analyze/file" $ do
    files >>= decodeFile

testi = get "/testi" $ do decodeFile []

decodeFile [(a,_)] = do
    raw . encodeUtf8 $ a
decodeFile _ = do
    status badRequest400
    json . pair $ ("error","Expect one, and only one file to be uploaded")

