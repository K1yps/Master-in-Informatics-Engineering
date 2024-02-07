-------------------------------- MODULE Ras --------------------------------

EXTENDS Naturals

CONSTANT N

ASSUME /\ N > 2
       /\ N % 2 = 0
VARIABLES stones

vars == <<stones>>

middle == N \div 2

pos == 0..N+1

TypeOK == stones \in [pos -> {"Brown" , "Green", "Empty"}]


Init == stones = [ p \in pos |-> IF p > middle THEN "Green" ELSE IF p = middle THEN "Empty" ELSE "Brown" ]
       
       
JumpGreen[p \in pos] == /\ stones[p] =  "Green"
                        /\ \/ /\ p > 0
                              /\ stones[p - 1] = "Empty"   
                              /\ stones' = [stones EXCEPT ![p] = "Empty", ![p-1] = "Green" ]
                           \/ /\ p > 1
                              /\ stones[p - 2] = "Empty"   
                              /\ stones' = [stones EXCEPT ![p] = "Empty", ![p-2] = "Green" ]
                             
JumpBrown[p \in pos] == /\ stones[p] =  "Brown"
                        /\ \/ /\ p < N + 1
                              /\ stones[p + 1] = "Empty"   
                              /\ stones' = [stones EXCEPT ![p] = "Empty", ![p+1] = "Brown" ]
                           \/ /\ p < N
                              /\ stones[p + 2] = "Empty"   
                              /\ stones' = [stones EXCEPT ![p] = "Empty", ![p+2] = "Brown" ]


End == \E a, b \in pos : /\ b >= a 
                         /\ \A x \in 0..a : stones[x] = "Green"       
                         /\ \A x \in a..b : stones[x] = "Empty"       
                         /\ \A x \in b..N+1 : stones[x] = "Brown"       
                             
Next == \E p \in pos : JumpGreen[p] \/ JumpBrown[p]


Spec == Init /\ [][Next]_vars



=============================================================================
\* Modification History
\* Last modified Thu May 19 10:33:36 WEST 2022 by k1yps
\* Created Thu May 19 10:02:23 WEST 2022 by k1yps
