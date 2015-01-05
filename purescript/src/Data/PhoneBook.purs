module Data.PhoneBook where

import Data.List
import Data.Maybe
import Control.Plus (empty)

---

type Entry = { fName :: String, lName :: String, phone :: String }

type PhoneBook = List Entry

---

showEntry :: Entry -> String
showEntry e = e.lName ++ " " ++ e.fName ++ " : " ++ e.phone

emptyBook :: PhoneBook
emptyBook = empty

insertEntry :: Entry -> PhoneBook -> PhoneBook
insertEntry = Cons

findEntry :: String -> String -> PhoneBook -> Maybe Entry
findEntry fn ln = head <<< filter (\e -> e.fName == fn && e.lName == ln)

isNameIn :: String -> PhoneBook -> Boolean
isNameIn n = not <<< null <<< filter (\e -> e.fName == n)

unique :: PhoneBook -> PhoneBook
unique = nubBy (\e1 e2 -> e1.fName == e2.fName && e1.lName == e2.lName)
