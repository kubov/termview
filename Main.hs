{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

module Main where
import Yesod
import KlaczDB

data TermView = TermView

mkYesod "TermView" [parseRoutes|
/ HomeR GET
/terms/#String TermsR GET
/members/ MembersR GET
/entriesof/#String EntriesOfR GET
|]

instance Yesod TermView

getHomeR :: Handler Html
getHomeR = do
  terms <- liftIO getTerms
  defaultLayout $(whamletFile "templates/homepage.hamlet")

getTermsR :: String -> Handler Html
getTermsR term = do
  entires <- liftIO $ getEntries term
  defaultLayout $(whamletFile "templates/getTerms.hamlet")

getMembersR :: Handler Html
getMembersR = do
  members <- liftIO getMembers
  defaultLayout $(whamletFile "templates/getMembers.hamlet")

getEntriesOfR :: String -> Handler Html
getEntriesOfR term = do
  entires <- liftIO $ getEntriesOf term
  defaultLayout $(whamletFile "templates/getEntriesOf.hamlet")

main :: IO ()
main = warp 3000 TermView
