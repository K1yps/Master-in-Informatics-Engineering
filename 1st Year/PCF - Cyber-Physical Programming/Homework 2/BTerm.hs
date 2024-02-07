module BTerm where

import LTerm

data BTerm = Leq LTerm LTerm | Conj BTerm BTerm | Neg BTerm deriving (Show)

bSem :: BTerm -> (Var -> Double) -> Bool
bSem (Leq t1 t2) m = let r1 = lSem t1 m
                         r2 = lSem t2 m in if r1 <= r2 then True else False
bSem (Neg b) m = let v = bSem b m in not v
bSem (Conj b1 b2) m = let v1 = bSem b1 m
                          v2 = bSem b2 m in v1 && v2

b = Leq t t'

c = Neg b