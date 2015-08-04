{-# LANGUAGE TemplateHaskell #-}

-- | Generate OpenGL coordinates for a decagonal prism to be used in
-- a Tetris game as a rotating score counter.

module Point where

import Control.Lens hiding (prism)
import Linear.Metric
import Linear.V2 hiding (angle)
import Linear.V3
import Linear.Vector
import Text.Printf

---

-- | Three location values, three colour values, and three normal values.
data Vertex = Vertex { _loc :: V3 Float
                     , _col :: V3 Float
                     , _nor :: V3 Float
                     , _tex :: V2 Float } deriving (Eq)
makeLenses ''Vertex

instance Show Vertex where
  show (Vertex l c n t) = unwords $ map showV3 [l,c,n] ++ [showV2 t]

showV3 :: V3 Float -> String
showV3 (V3 x y z) = printf "%.3f,%.3f,%.3f," x y z

showV2 :: V2 Float -> String
showV2 (V2 x y) = printf "%.3f,%.3f," x y

tau :: Float
tau = 6.283185

-- | lightPos = coglV3(cos(lightAngle),1.0f,sin(lightAngle));
fromAngle :: Float -> Float -> V3 Float
fromAngle xoff angle = V3 xoff (h * sin angle) (h * cos angle)
  where h = 0.5 / cos (tau / 20)

-- | The outer vertices of a decagon. Infinite list.
points :: Float -> [V3 Float]
points xoff = map (fromAngle xoff) angles
  where angles = iterate (+ (tau / 10)) (tau / 20)

-- | A decagon, one side of the prism. Here we produce the complete
-- `Vertex` object with location, colour, normal, and texture points.
decagon :: Float -> Float -> [Vertex]
decagon xoff texX = zipWith ($) vs ts
  where vs = map g . f $ points xoff
        f [_]      = []
        f (x:y:zs) = x : y : V3 xoff 0 0 : f (y:zs)
        g point    = Vertex point (V3 0.5 0.5 0.5) (V3 normx 0 0)
        normx      = if xoff > 0 then 1 else (-1)
        ts         = h $ iterate (+ V2 0 0.1) $ V2 texX 0
        h (x:y:zs) = x : y : V2 (-1) (-1) : h (y:zs)

-- | The triangles that make up the surrounding "band" of the prism.
band :: [Vertex] -> [Vertex] -> [Vertex]
band [_] [_] = []
band (a:b:cs) (x:y:zs) = vs ++ band (b:cs) (y:zs)
  where normal = normalize $ cross (_loc b ^-^ _loc a) (_loc x ^-^ _loc a)
        vs     = [a,b,x,x,y,b] & traverse . nor .~ normal

-- | All the vertices of a decagonal prism.
prism :: [Vertex]
prism = take 30 d1 ++ take 30 d2 ++ take 60 (band (f d1) (f d2))
  where d1 = decagon 0.125 1
        d2 = decagon (-0.125) 0
        f [] = []
        f xs = head xs : f (drop 3 xs)
