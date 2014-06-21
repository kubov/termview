{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

module Main where
import Yesod
import KlaczDB

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/term/#String TermR GET
/members/ MembersR GET
/entriesof/#String EntriesOfR GET
|]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = do
  terms <- liftIO $ getTerms
  defaultLayout [whamlet|
                 <h2>termview
                 <h4><a href="@{MembersR}">check entries of members
                 <ul>
                   $forall (name,count) <- terms
                           <li><a href="@{TermR name}">#{name} (#{count})
                 |]

getTermR :: String -> Handler Html
getTermR term = do
  entires <- liftIO $ getEntries term
  defaultLayout [whamlet|
                 <h3>#{term}

                 <table>
                   <tr>
                   $forall (by,text) <- entires
                     <tr>
                       <td>#{by}
                       <td><b>#{text}

                 <h4><a href="@{HomeR}">home
               |]

getMembersR :: Handler Html
getMembersR = do
  members <- liftIO getMembers
  defaultLayout [whamlet|
                 <h2>Entries of
                 <h4><a href="@{HomeR}">home
                 <ul>
                   $forall (name,count) <- members
                           <li><a href="@{EntriesOfR name}">#{name} (#{count})
                 |]

getEntriesOfR :: String -> Handler Html
getEntriesOfR term = do
  entires <- liftIO $ getEntriesOf term
  defaultLayout [whamlet|
                 <h3>#{term} added
                 <table>
                   <tr>
                   $forall (by,text) <- entires
                     <tr>
                       <td>#{by}
                       <td><b>#{text}

                 <h4><a href="@{MembersR}">home
               |]

main :: IO ()
main = warp 3000 HelloWorld
