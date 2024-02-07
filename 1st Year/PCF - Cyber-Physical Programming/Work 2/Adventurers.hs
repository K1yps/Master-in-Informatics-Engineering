{-# LANGUAGE FlexibleInstances #-}
module Adventurers where

import DurationMonad

-- The list of adventurers
data Adventurer = P1 | P2 | P5 | P10 deriving (Show, Eq, Ord)

-- List of all of the possible adventures
allAdventurers :: [Adventurer]
allAdventurers = [P1, P2, P5, P10]

-- The time that each adventurer needs to cross the bridge
getTimeAdv :: Adventurer -> Int
getTimeAdv P1 = 1
getTimeAdv P2 = 2
getTimeAdv P5 = 5
getTimeAdv P10 = 10

-- Adventurers + the lantern
type Objects = Either Adventurer ()

-- The lantern
lantern :: Objects
lantern = Right ()

-- List of all of the possible adventur objects
allAdventurersObjects :: [Objects]
allAdventurersObjects = map Left allAdventurers

-- List of all of the possible objects
allObjects :: [Objects]
allObjects = lantern:allAdventurersObjects

-- The time that a object needs to cross the bridge
getTimeObject :: Objects -> Int
getTimeObject = either getTimeAdv (const 0)


{-- The state of the game, i.e. the current position of each adventurer
+ the lantern. The function (const False) represents the initial state
of the game, with all adventurers and the lantern on the left side of
the bridge. Similarly, the function (const True) represents the end
state of the game, with all adventurers and the lantern on the right
side of the bridge.  --}
type State = Objects -> Bool

instance Show State where
  show s = (show . fmap (show . s)) allObjects

instance Eq State where
  (==) s1 s2 = all (\x -> s1 x == s2 x) allObjects

-- The initial state of the game
gInit :: State
gInit = const False

-- The final state of the game
gEnd :: State
gEnd = const True

-- Changes the state of the game for a given object
changeState :: Objects -> State -> State
changeState a s = let v = s a in (\x -> if x == a then not v else s x)

-- Changes the state of the game of a list of objects 
mChangeState :: [Objects] -> State -> State
mChangeState os s = foldr changeState s os

-- Lists all the adventures moves from the given list of objects
adventurerPlays  :: [Objects] -> [[Objects]]
adventurerPlays l = [[x] | x <- l, isLeft x] ++ [[x,y] | x <- l, isLeft x, y <- l, isLeft y, x > y]
                        where isLeft = either (const True) (const False)

-- Lists all valid plays from the given state
validPlays :: State -> [[Objects]]
validPlays s = map (lantern:) (adventurerPlays (filter (\x -> s x == s lantern) allAdventurersObjects))

-- Applies the plays changes to the list of durations
applyPlay :: [Objects] -> ListDur a -> ListDur a
applyPlay os = let t = maximum (map getTimeObject os) 
                   in composeDurations (wait t . return)

-- Moves the given Objects
play :: State  -> [Objects] -> ListDur State
play s p = (applyPlay p . return .  mChangeState p) s 

{-- For a given state of the game, the function presents all the possible moves that the adventurers can make.  --}
allValidPlays :: State -> ListDur State
allValidPlays s = manyChoice (map (play s) (validPlays s))

{-- For a given number n and initial state, the function calculates all possible n-sequences of moves that the adventures can make --}
exec :: Int -> State -> ListDur State
exec n s= if n <= 0 
          then return s
          else do newSs <- allValidPlays s
                  exec (n - 1) newSs


endedLeq :: Int -> ListDur State -> Bool
endedLeq i = anyDuration (\x -> (getDuration x <= i) && (getValue x == gEnd))

{-- Is it possible for all adventurers to be on the other side in <=17 min and not exceeding 5 moves ? --}
leq17 :: Bool
leq17 =  any (endedLeq 17 . \x -> exec x gInit) [1..5]     

{-- Is it possible for all adventurers to be on the other side in < 17 min ? --}
l17 :: Bool
l17 =  execd (gEnd ==) (\d -> 17 > getDuration d) (return gInit)

-- Searches for a execution from the given List of states that satisfies the first and second predicate.
-- Additionaly all states preceding the possible execution will also satisfy the second predicate.
execd :: (State -> Bool) -> (Duration State -> Bool) -> ListDur State -> Bool 
execd f g ls = let exec = filterDuration g (ls >>= allValidPlays)
             in not(isEmpty ls) && (anyDuration (f . getValue) exec || execd f g exec)

--------------------------------------------------------------------------
{-- Implementation of the monad used for the problem of the adventurers. --}

data ListDur a = LD [Duration a] deriving Show

remLD :: ListDur a -> [Duration a]
remLD (LD x) = x

isEmpty :: ListDur a -> Bool
isEmpty = null . remLD

filterDuration :: (Duration  a -> Bool) -> ListDur a-> ListDur a 
filterDuration f = LD . filter  f . remLD

anyDuration :: (Duration  a -> Bool)-> ListDur a -> Bool
anyDuration f = any  f . remLD

allDuration :: (Duration  a -> Bool)-> ListDur a -> Bool
allDuration f = all  f . remLD

composeDurations :: (a -> Duration  b) -> ListDur a -> ListDur b
composeDurations f = LD . map (>>= f) . remLD

instance Functor ListDur where
   fmap f l = LD (map (fmap f) (remLD l))

instance Applicative ListDur where
   pure x = LD [pure x]
   l1 <*> l2 =  LD [f <*> x | f <- remLD l1, x <- remLD l2 ] 

instance Monad ListDur where
   return = pure
   l >>= k =  LD $ do x <- remLD l
                      map (\d -> x >>= const d ) (remLD (k (getValue x)))

manyChoice :: [ListDur a] -> ListDur a
manyChoice = LD . concatMap remLD
