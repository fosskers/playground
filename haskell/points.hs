-- | Generate OpenGL coordinates for a decagonal prism to be used in
-- a Tetris game.

module Point where

import Control.Lens hiding (prism)

---

-- | Three location values, and three colour values.
type Vertex = (Float,Float,Float,Float,Float,Float)

tau :: Float
tau = 6.283185

-- | lightPos = coglV3(cos(lightAngle),1.0f,sin(lightAngle));
fromAngle :: Float -> Float -> (Float,Float,Float)
fromAngle xoff angle = (xoff, h * sin angle, h * cos angle)
  where h = 0.5 / cos (tau / 20)

points :: Float -> [(Float,Float,Float)]
points xoff = map (fromAngle xoff) angles
  where angles = iterate (+ (tau / 10)) (tau / 20)

-- | Taking 11 points ensures we wrap back around to the starting point.
-- Includes colour information.
decagon :: Float -> [Vertex]
decagon xoff = map g . f . take 11 $ points xoff
  where f [_]      = []
        f (x:y:zs) = x : y : (xoff,0,0) : f (y:zs)
        g (x,y,z)  = (x,y,z,0.5,0.5,0.5)  -- Gray.

-- | The triangles that make up the surrounging "band" of the prism.
band :: [Vertex] -> [Vertex] -> [Vertex]
band ps rs = f (ps ++ [head ps]) (rs ++ [head rs])
  where f [_] [_] = []
        f (a:b:cs) (x:y:zs) = a : b : x : x : y : b : f (b:cs) (y:zs)

prism :: [(Float,Float,Float,Float,Float,Float)]
prism = d1 ++ d2 ++ band (f d1) (f d2)
  where d1 = decagon 0.25
        d2 = decagon (-0.25)
        f [] = []
        f xs = head xs : f (drop 3 xs)
