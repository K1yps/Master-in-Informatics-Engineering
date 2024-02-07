------------------------ MODULE Candidate ------------------------


EXTENDS Naturals

CONSTANT N

ASSUME /\ N > 0


VARIABLES uid


Relations == [i \in 0..N-1 |-> i+1  ] \union [N -> 0]
RelationsConverse == [i \in 1..N |-> i-1] \union [0 -> N]

Init == uid = [0..N -> 0..N]


CanBeCandidate[n \in 0..N] == /\ uid[RelationsConverse[n]] # uid[n]
                              /\ uid[Relations[n]] > uid[n]
                                   
     
                







=============================================================================
\* Modification History
\* Last modified Thu May 19 10:00:17 WEST 2022 by k1yps
\* Created Thu May 19 09:44:37 WEST 2022 by k1yps
