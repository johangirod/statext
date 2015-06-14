{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Application where

import           Control.Lens.TH
import           Snap
import           Data.ByteString (ByteString)
import           Api.Core(Api(Api), apiInit)

data App = App { _api :: Snaplet Api }


makeLenses ''App

-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = []

app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    api <- nestSnaplet "api" api apiInit
    addRoutes routes
    return $ App api