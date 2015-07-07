{-# LANGUAGE OverloadedStrings #-}

module Main where

import Api.Core

import Web.Scotty
import Network.Wai.Middleware.Static


main = scotty 3000 $ do
    --serve API
    apiRoutes
    --serve static content
    get "" $ do
        file "src/front/index.html"
        setHeader "Content-Type" "text/html; charset=utf-8"
    middleware $ staticPolicy (noDots >-> addBase "src/front")
