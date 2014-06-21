module KlaczDB where

import Database.HDBC
import Database.HDBC.PostgreSQL

conection = connectPostgreSQL "host=localhost user=klacz password=klacz"

getTermsQuery = "select _name, count(*) from _entry join _term on (_term._oid = _entry._term_oid) where _term._visible = 't' and _entry._visible = 't' group by _name order by _name;"

getEntriesQuery = "select _added_by,_text from _entry join _term on (_term._oid = _entry._term_oid) where _entry._visible = 't' and _term._visible = 't' and _name = ? order by _entry._oid DESC;"

getMembersQuery = "select _added_by, count(*) as cc from _entry join _term on (_term._oid = _entry._term_oid) where _term._visible = 't' and _entry._visible = 't' group by _added_by having count(*) > 0 order by _added_by;"

getEntriesOfQuery = "select _name,_text from _entry join _term on (_term._oid = _entry._term_oid) where  _term._visible = 't' and _entry._visible = 't' and _added_by = ? order by _entry._oid DESC;"

queryPair :: String -> [SqlValue] -> IO [(String,String)]
queryPair query params = do
  con <- conection
  vals <- quickQuery' con query params
  return (map unwrap vals) where
    unwrap [f, s] = (fromSql f, fromSql s)

getTerms, getMembers :: IO [(String,String)]
getTerms = queryPair getTermsQuery []
getMembers = queryPair getMembersQuery []

getEntriesOf, getEntries :: String -> IO [(String, String)]
getEntries term = queryPair getEntriesQuery [toSql term]
getEntriesOf term = queryPair getEntriesOfQuery [toSql term]
