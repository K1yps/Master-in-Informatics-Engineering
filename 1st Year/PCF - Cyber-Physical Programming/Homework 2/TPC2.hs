module TPC2 where

-- Henrique Gabriel dos Santos Neto PG47238

-- (1) Syntax

-- Definition of Linear Memory
type LMem =  (Var -> Double)

-- Defenition of the Variables data type
data Var = A | B | C | D | E | F | X | Y | Z | W | V | T | S | P | Q 
    deriving (Show, Eq, Enum, Bounded)

-- Definition of a Linear Term
data LTerm = Leaf (Either Var Double) | Scl Double LTerm | Add LTerm LTerm   

-- Instance of Show for Linear terms (for better printing)
instance Show LTerm where
    show(Leaf a) = either (show) (show) a
    show(Scl a b) = show a ++ "*" ++ show b
    show(Add a b) = show a ++ "+" ++ show b

-- Definition of a Boolean Term
data BTerm = Leq LTerm LTerm | Conj BTerm BTerm | Neg BTerm | Const Bool

-- Instance of Show for Boolean terms (for better printing)
instance Show BTerm where
    show(Leq a b) = show a ++ "=<" ++ show b
    show(Conj a b) = show a ++ "/\\" ++ show b
    show(Neg a) = "~" ++ show a 
    show(Const a) = show a

-- Definition of "Wait" Memory (Duration >< Linear Memory)
type WMem = (Double, LMem)

-- Definion of a "While/Wait" term (this is the implemented language)
data WTerm = Asg Var LTerm |  Wait Double WTerm | Seq WTerm WTerm | If BTerm WTerm WTerm | While BTerm WTerm

-- Instance of Show for "While/Wait" term terms (for better printing)
instance Show WTerm where
    show(Asg a b) = show a ++ ":=" ++ show b
    show(Wait a b) = "wait_" ++ show a ++ "(" ++ show b ++ ")"
    show(Seq a b) = show a ++ ";" ++ show b
    show(If a b c) = "if (" ++ show a ++ ") then " ++ show  b ++ " else " ++ show c 
    show(While a b) = "while (" ++ show a ++ ") do {" ++ show b ++ "}"

-- (2) Semantics 

-- Linear Semantics
lSem :: LTerm -> LMem -> Double 
lSem (Leaf (Left v)) m = m v
lSem (Leaf (Right r)) _ = r
lSem (Scl s t) m = let r = lSem t m in s * r
lSem (Add t1 t2) m = let r1 = lSem t1 m
                         r2 = lSem t2 m in r1 + r2

-- Boolean Semantics
bSem :: BTerm -> LMem -> Bool
bSem (Leq t1 t2) m = let r1 = lSem t1 m
                         r2 = lSem t2 m in if r1 <= r2 then True else False
bSem (Neg b) m = let v = bSem b m in not v
bSem (Conj b1 b2) m = let v1 = bSem b1 m
                          v2 = bSem b2 m in v1 && v2
bSem (Const c) _ = c

-- Memory Change function
changeMem :: Var -> Double -> LMem -> LMem
changeMem v newValue s = \v' -> if v == v' then newValue else s v'

-- Wait/While Semantics
wSem :: WTerm -> LMem -> WMem
wSem (Asg  x t) sig = let sig' = changeMem x (lSem t sig) sig in (0, sig')
wSem (Wait m p) sig = let (n, sig' ) = wSem p sig  in (m + n, sig' )
wSem (Seq  p q) sig = let (n, sig' ) = wSem p sig
                          (m, sig'') = wSem q sig' in (n + m, sig'')
wSem (If b p q) sig = if (bSem b sig) 
                        then wSem p sig 
                        else wSem q sig
wSem (While b p) sig = if (bSem b sig) 
                        then let (n, sig') = wSem p sig
                                 (m, sig'') = wSem (While b p) sig' in (n + m, sig'')
                        else (0, sig)

-- (3) Examples 

-- Utilities for Linear Terms
lRight = Leaf . Right
lLeft = Leaf . Left
-- Returns the duration of the run
duration = fst
-- Returns the resulting linear memory of the run
mem = snd
-- Checks if 2 linear memories are equal
memEqual :: LMem -> LMem -> Bool
memEqual mem1 mem2 = foldr (&&) True (map (\x -> mem1 x == mem2 x) [(minBound :: Var) ..])

-- Simplifications for the examples
x = lLeft X
y = lLeft Y
z = lLeft Z
a = lLeft A
b = lLeft B

-- Definition of a base memory. Different variables are used on each example to allow for the use of the same memory in each without colisions.
m X = 0
m Y = 5
m Z = 0
m A = 1
m B = 6
m _ = 0 -- Wildcart definition to avoid non exhaustive patterns exception

-- Example 1
example1 = While (Leq x y)  (Seq  (Wait 1.0 (Asg Z  (Add z x) )) (Wait 1.0 (Asg X (Add x (lRight 1) ))))

run_ex1 = wSem example1 m

-- Example 2

example2 = If (Leq b a) (Wait 10 (Asg A (Add a b))) (While (Leq a b)  (Wait 1.0 (Asg A ((Scl 2 a )))))

run_ex2 = wSem example2 m

-- Example 3

example3_1 = Wait 2.0 (Wait 1.0 (Asg A a))

example3_2 = Wait (2.0+1.0) (Asg A a)

run_ex3_1 = wSem example3_1 m

run_ex3_2 = wSem example3_2 m

