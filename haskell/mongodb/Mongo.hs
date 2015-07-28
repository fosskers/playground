{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Mongo where

import Control.Monad.IO.Class (liftIO)
import Data.Time.Clock
import Database.MongoDB

---

{-| Some cats -}
jack :: UTCTime -> Document
jack t = [ "name"   =: "Jack"
         , "gender" =: "雄"  -- Some UTF8
         , "age"    =: 2
         , "food"   =: "hard"
         , "hobby"  =: "Waking me up at 5 a.m."
         , "added"  =: t ]

miso :: UTCTime -> Document
miso t = [ "name"   =: "Miso"
         , "gender" =: "雌"
         , "age"    =: 8
         , "food"   =: "hard"
         , "hobby"  =: "Shedding"
         , "added"  =: t ]

tinsel :: UTCTime -> Document
tinsel t = [ "name"   =: "Tinsel"
           , "gender" =: "雌"
           , "age"    =: 12
           , "food"   =: "soft"
           , "hobby"  =: "Sleeping"
           , "added"  =: t ]

{-| Creates a pipe and runs some read/write Action. -}
mongo :: Action IO a -> IO a
mongo act = do
  pipe <- connect $ host "127.0.0.1"
  r <- access pipe master "playground" act
  close pipe
  return r

write :: Document -> Action IO Value
write d = insert "cats" d

{- | We can query on fields -}
read1 :: Action IO (Maybe Document)
read1 = findOne $ select ["name" =: "Jack"] "cats"

{- | Throws an exception if it fails -}
fetch1 :: Action IO Document
fetch1 = fetch $ select ["name" =: "Sam"] "cats"

writeMany :: Action IO [Value]
writeMany = do
  t <- liftIO getCurrentTime
  insertMany "cats" [jack t, miso t, tinsel t]

readMany :: Action IO [Document]
readMany = find (select ["food" =: "hard"] "cats") >>= rest

-- | Updating
update :: Action IO ()
update = read1 >>= f
  where f Nothing  = return ()
        f (Just c) = save "cats" $ merge ["hobby" =: "Sleeping"] c

-- | Counting
howManyCats :: Action IO Int
howManyCats = count $ select [] "cats"

proj :: Action IO [Document]
proj = find (select [] "cats") {project = ["name" =: 1, "_id" =: 0]} >>= rest

{- | Kill all the cats -}
bye :: Action IO ()
bye = delete $ select [] "cats"

