module XML where

import           Data.Graph
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import           Data.Tree
import           Text.XML.Light.Input
import           Text.XML.Light.Types

---

{- | NOTES - What is this for?

This breaks apart potentially cyclic graphs into topologically sorted
spanning trees. In the context of OSM, this allows us to break apart illegal
Relation graphs.

The key algorithm is:

g :: Graph

(dfs g $ topSort g) :: Forest Vertex

-}

-- | Read some XML file.
osm :: FilePath -> IO T.Text
osm fp = T.unlines . drop 138218 . T.lines <$> TIO.readFile fp

-- | Parse and filter OSM Relations.
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

-- | All ID references to other Elements.
memberRefs :: Element -> [String]
memberRefs = foldr f [] . elContent
  where f (Elem e@(Element { elName = QName { qName = "member" }})) acc = (attrVal . head . filter g $ elAttribs e) : acc
        f _ acc = acc
        g (Attr (QName { qName = "ref" }) _) = True
        g _ = False

-- | Find all the spanning trees of this (multi) graph.
-- Consider: osm fpath >>= mapM_ print . relTree
relTree :: T.Text -> Forest String
relTree t = map (fmap (first . key)) $ dfs g (topSort g)
  where (g, key, _) = graphFromEdges trips
        trips = map f . zip bsIds $ map (\b -> filter (`elem` bsIds) $ memberRefs b) bs
        f (k, keys) = (k, k, keys)
        bs = filter isBoundary $ relations t
        bsIds = map iden bs

tree :: Tree Int
tree = Node 52411 $ Node 53136 rest : rest
  where rest = [Node 53134 [Node 53114 [Node 2524404 [Node 53137 []]]]]

fpath :: FilePath
fpath = "/home/colin/code/playground/haskell/xml/baarle-nassau.osm"

first :: (a,b,c) -> a
first (a,_,_) = a

nassau = graphFromEdges [ (52411, 52411, [53136, 53134])
                        , (53136, 53136, [53134])
                        , (53134, 53134, [53114])
                        , (53114, 53114, [2524404])
                        , (2524404, 2524404, [53137])
                        , (53137, 53137, [])
                        ]

graphy :: (Graph, Vertex -> (Integer, Integer, [Integer]), Integer -> Maybe Vertex)
graphy = graphFromEdges [ (1, 1, [2,3])
                        , (2, 2, [4])
                        , (3, 3, [4])
                        , (4, 4, [])
                        , (5, 5, [6,7])
                        , (6, 6, [8])
                        , (7, 7, [8])
                        , (8, 8, [])
                        ]

foo :: [Tree String]
foo = map (fmap (show . first . key)) $ dfs g (topSort g)
  where (g, key, _) = graphy

bar :: (Graph, Vertex -> (b, b1, c), t) -> [Tree b]
bar (g, key, _) = map (fmap (first . key)) . dfs g $ topSort g

{-

("297220",[])
("47798",[])
("53137",[])
("2718258",[])
("2718379",[])
("3363871",[])
("47796",[])
("52411",["53134","53136"])
("2524404",["53137"])
("53114",["2524404"])
("47696",[])
("2323309",["47796"])
("53136",["53134"])
("53134",["53114"])

-}
