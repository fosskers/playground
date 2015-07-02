{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Mongo where

import Database.MongoDB

---

{-| Some cats -}
jack :: Document
jack = [ "name"   =: "Jack"
       , "gender" =: "雄"  -- Some UTF8
       , "age"    =: 2
       , "food"   =: "hard"
       , "hobby"  =: "Waking me up at 5 a.m." ]

miso :: Document
miso = [ "name"   =: "Miso"
       , "gender" =: "雌"
       , "age"    =: 8
       , "food"   =: "hard"
       , "hobby"  =: "Shedding" ]

tinsel :: Document
tinsel = [ "name"   =: "Tinsel"
         , "gender" =: "雌"
         , "age"    =: 12
         , "food"   =: "soft"
         , "hobby"  =: "Sleeping" ]

{-| Creates a pipe and runs some read/write Action. -}
mongo :: Action IO a -> IO a
mongo act = do
  pipe <- connect $ host "127.0.0.1"
  access pipe master "playground" act

write :: Document -> Action IO Value
write d = insert "cats" d

{- | We can query on fields -}
read1 :: Action IO (Maybe Document)
read1 = findOne $ select ["name" =: "Jack"] "cats"

{- | Throws an exception if it fails -}
fetch1 :: Action IO Document
fetch1 = fetch $ select ["name" =: "Sam"] "cats"

writeMany :: Action IO [Value]
writeMany = insertMany "cats" [jack,miso,tinsel]

readMany :: Action IO [Document]
readMany = find (select ["food" =: "hard"] "cats") >>= rest

howManyCats :: Action IO Int
howManyCats = count $ select [] "cats"

proj :: Action IO [Document]
proj = find (select [] "cats") {project = ["name" =: 1, "_id" =: 0]} >>= rest

{- | Kill all the cats -}
bye :: Action IO ()
bye = delete $ select [] "cats"
