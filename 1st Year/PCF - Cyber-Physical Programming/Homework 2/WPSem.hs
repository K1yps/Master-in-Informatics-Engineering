module WhilePrograms where

import Cp
import LTerm
import BTerm

-- (1) Datatype definition -----------------------------------------------------

data WP = Ass Var LTerm | Seq WP WP | If BTerm WP WP | Wh BTerm WP

pr = Wh (Geq x y) (Seq (Ass X (Add x y)) (Ass Y (Add y z)))

-- (2) Semantics ---------------------------------------------------------------

chMem :: Var -> Double -> (Var -> Double) -> (Var -> Double)
chMem v newValue s = \v' -> if v == v' then newValue else s v'

wpSem :: WP -> (Var -> Double) -> (Var -> Double)
wpSem (Ass v t) m = chMem v (lSem t m) m
wpSem (Seq p q) m = let
                     m' = wpSem p m
                     m'' = wpSem q m' in m''
wpSem (If b p q) m = if (bSem b m) then wpSem p m else wpSem q m
wpSem (Wh b p) m = if (bSem b m) then
    let m' = wpSem p m in wpSem (Wh b p) m'
    else m