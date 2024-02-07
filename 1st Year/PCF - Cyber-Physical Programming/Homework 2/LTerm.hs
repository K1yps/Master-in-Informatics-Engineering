module LTerm where



data Var = X | Y | Z
    deriving (Show, Eq, Ord)

data LTerm = Leaf (Either Var Double) | Scl Double LTerm | Add LTerm LTerm   
    deriving (Show)



lSem :: LTerm -> (Var -> Double) -> Double 
lSem (Leaf (Left v)) m = m v
lSem (Leaf (Right r)) _ = r
lSem (Scl s t) m = s * lSem t m
lSem (Add t1 t2) m = lSem t1 m + lSem t2 m



lleaf = Leaf . Left 

-- x
x = lleaf X
y = lleaf Y
z = lleaf Z

t = Add x (Scl 2 y)
t' = Add (Scl 2 x) (Scl 2 y)


m X = 3
m Y = 4
m Z = 5




