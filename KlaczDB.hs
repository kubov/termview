module KlaczDB where

import Database.HDBC
import Database.HDBC.PostgreSQL

conection = connectPostgreSQL "host=localhost user=klacz"

getTermsQuery = "select _name, count(*) from _entry join _term on (_term._oid = _entry._term_oid) group by _name;"
getEntriesQuery = "select _added_by,_text from _entry join _term on (_term._oid = _entry._term_oid) where _name = ? order by _entry._oid DESC;"

getTerms :: IO [(String,Int)]
getTerms  = do
  con <- conection
  vals <- quickQuery' con getTermsQuery []
  return (map unwrap vals) where
    unwrap [desc, count] = (fromSql desc, fromSql count)
      
      
getEntries :: String -> IO [(String, String)]
getEntries term = do
  con <- conection
  vals <- quickQuery' con getEntriesQuery [toSql term]
  return (map unwrap vals) where
    unwrap [by, text] = (fromSql by, fromSql text)
