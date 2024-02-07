---------------------------- MODULE Nyahahahaaaa ----------------------------

EXTENDS Integers, Sequences

Remove(i, seq) == 
  [j \in 1..(Len(seq)-1) |-> IF j < i THEN seq[j] 
                                      ELSE seq[j+1]]
                                      
                                      
                                  
=============================================================================
\* Modification History
\* Last modified Wed May 18 18:07:51 WEST 2022 by k1yps
\* Created Wed May 18 18:07:41 WEST 2022 by k1yps
