module Chapter2 where

import Debug.Trace
import Math
    
---

main = print $ diagonal 3 4

diagonal :: Number -> Number -> Number
diagonal w h = sqrt $ w * w + h * h

circleArea :: Number -> Number
circleArea r = pi * r * r
