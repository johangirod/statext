module Main where 

import Application
import Snap.Snaplet
import Snap.Http.Server.Config

main :: IO ()
main = serveSnaplet defaultConfig app