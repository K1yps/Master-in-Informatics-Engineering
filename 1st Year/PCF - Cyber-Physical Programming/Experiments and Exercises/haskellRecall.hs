{- Cyber-Physical Programming 2021/2022 - Recalling Haskell.
 - Why Haskell? We will use Haskell in this course to implement
 - programming languages and respective semantics.
 - Author: Renato Neves.
 - Goal: Solve the exercises listed below.
-}
module LectureCPC where

import Cp
import Data.Char
import List

-- Basic functions and conditionals --

-- Implement the function that returns
-- the maximum of two integers.
max :: (Int, Int) -> Int
max = either p1 p2 . grd (uncurry (>))

-- Implement the function that returns
-- the maximum of three integers.
max3 :: (Int, (Int, Int)) -> Int
max3 = LectureCPC.max . (id >< LectureCPC.max)

-- Implement the function that scales
-- a 2-dimensional real vector by a
-- real number.
scaleV :: (Double, (Double, Double)) -> (Double, Double)
scaleV (a, (b, c)) = (a * b, a * c)

-- Implement the function that adds up
-- two 2-dimensional real vectors
addV :: ((Double, Double), (Double, Double)) -> (Double, Double)
addV ((a, b), (c, d)) = (a + c, b + d)

-- Type Synonims
type TSMatrix = ((Double, Double), (Double, Double))

type TVector = (Double, Double)

multM :: (TSMatrix, TVector) -> TVector
multM (((a, b), (c, d)), (e, f)) = (a * e + c * f, b * e + d * f)

-- nao me apetece tar a ver a teoria de tensores para fazer isto pointfree
--------------------------------------

-- Recursion -------------------------

-- Implement the function that calculates
-- the factorial of an integer
fact :: Int -> Int
fact = hyloList a b
  where
    a = either (const 1) (uncurry (*))
    b = ((const 1) -|- (split id (cosucc))) . grd (1 >)
    cosucc x = x - 1

-- Implement the function that return the length
-- of a given list
len :: [a] -> Int
len = cataList g
  where
    g = either (const 0) (succ . p2)

-- Implement the function that removes all
-- the even numbers from a given list
odds :: [Int] -> [Int]
odds = cataList g
  where
    g = either (const []) ((either p2 cons) . grd (odd . p1))

-- Implement Caesar Cypher with shift=3
-- https://en.wikipedia.org/wiki/Caesar_cipher
-- Suggestion: add "import Data.Char", and use
-- the functions "chr" and "ord"

norm = id -- need to account for all ranges of the ascii table and i'm to lazy

ecode :: Int -> String -> String
ecode n = cataList g
  where
    g = either (const "") (cons . (chr . norm . (n +) . ord >< id))

dcode :: Int -> String -> String
dcode n = cataList g
  where
    g = either (const "") (cons . (chr . norm . minusn . ord >< id))
    minusn x = x - n

-- Implement the QuickSort algorithm
-- Think how to implement it in your favorite language
-- without using recursion
qSort :: [Int] -> [Int]
qSort = undefined

-- Implement the solution to the Hanoi problem
-- Think how to implement it in your favorite language
-- without using recursion
hanoi :: Int -> a -> a -> a -> [(a, a)]
hanoi = undefined

-- --------------------------------------

-- Datatypes ----------------------------

-- The datatype of leaf trees
data LTree a = Leaf a | Fork (LTree a, LTree a) deriving (Show)

outLTree (Leaf a) = i1 a
outLTree (Fork (a, b)) = i2 (a, b)

recLTree f = id -|- f >< f

cataLTree g = g . recLTree (cataLTree g) . outLTree

-- Implement the function that increments all values
-- in a given leaf tree
incr :: LTree Int -> LTree Int
incr = cataLTree g
  where
    g = either (Leaf . succ) (Fork)

-- Implement the function that counts the number of leafs
-- in a leaf tree
count :: LTree Int -> Int
count = cataLTree g
  where
    g = either (const 1) (uncurry (+))

-- The datatype of binary trees
data BTree a = Empty | Node a (BTree a, BTree a) deriving (Show)

-- Implement the function that increments all values
-- in a given binary tree
bincr :: BTree Int -> BTree Int
bincr = undefined

-- Implement the function that counts the number of leafs
-- in a leaf tree
bcount :: BTree Int -> Int
bcount = undefined

-- The datatype of "full" trees
data FTree a b = Tip a | Join b (FTree a b, FTree a b) deriving (Show)

-- Implement the function that sends a full tree into a leaf tree
fTree2LTree :: FTree a b -> LTree a
fTree2LTree = undefined

-- Implement the function that sends a full tree into a binary tree
fTree2BTree :: FTree a b -> BTree b
fTree2BTree = undefined

-- Implement the semantics of the following very simple
-- language of Arithmetic Expressions
data Vars = X1 | X2

data Ops = Sum | Mult

type AExp = FTree (Either Vars Int) Ops

type AState = Vars -> Int

semA :: (AExp, AState) -> Int
semA = undefined

-- The datatype of "rose" trees
data RTree a b = Rtip a | Rjoin b [RTree a b] deriving (Show)

-- Implement the semantics of the following very simple
-- language of Boolean Expressions
data BOps = Disj | Conj | Neg

type BExp = RTree (Either Vars Bool) BOps

type BState = Vars -> Bool

semB :: (BExp, BState) -> Bool
semB = undefined

-- Improve the two previous programming languages by defining
-- data types specific to them
--------------------------------------
