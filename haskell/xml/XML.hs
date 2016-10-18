module XML where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import           Data.Tree
import           Text.XML.Light.Input
import           Text.XML.Light.Types

---


osm :: FilePath -> IO T.Text
osm fp = T.unlines . drop 138218 . T.lines <$> TIO.readFile fp

relations :: T.Text -> [Element]
relations = foldr f [] . parseXML
  where f (Elem e@(Element { elName = QName { qName = "relation" }})) acc = e : acc
        f _ acc = acc

isBoundary :: Element -> Bool
isBoundary = any p . elContent
  where p (Elem e@(Element { elName = QName { qName = "tag" }})) = (elem k $ elAttribs e) && (elem v $ elAttribs e)
        p _ = False
        k = Attr (QName "k" Nothing Nothing) "type"
        v = Attr (QName "v" Nothing Nothing) "boundary"

-- | Get the ID of this Element.
iden :: Element -> String
iden = attrVal . head . filter g . elAttribs
  where g (Attr (QName { qName = "id"}) _) = True
        g _ = False

memberRefs :: Element -> [String]
memberRefs = foldr f [] . elContent
  where f (Elem e@(Element { elName = QName { qName = "member" }})) acc = (attrVal . head . filter g $ elAttribs e) : acc
        f _ acc = acc
        g (Attr (QName { qName = "ref" }) _) = True
        g _ = False

relTree :: T.Text -> [(String, [String])]
relTree t = zip bsIds $ map (\b -> filter (`elem` bsIds) $ memberRefs b) bs
  where bs = filter isBoundary $ relations t
        bsIds = map iden bs

tree :: Tree Int
tree = Node 52411 $ Node 53136 rest : rest
  where rest = [Node 53134 [Node 53114 [Node 2524404 [Node 53137 []]]]]
