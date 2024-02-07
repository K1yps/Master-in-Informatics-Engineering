------------------------------- MODULE Quinta -------------------------------
CONSTANT workers

VARIABLE sys

States == {"Working", "Prepared", "Aborted", "Commited"}

Init == sys = [w \in workers |-> "Working" ]
Prepared  == [w \in workers |-> "Prepared" ] 
Success == [w \in workers |-> "Commited" ]
Failure == [w \in workers |-> "Aborted"]


TypeOK == sys \in [workers -> States]



finished[p \in workers] ==  /\ sys[p] = "Working" 
                            /\ sys' = [sys EXCEPT ![p] = "Prepared"]
                            
canEnd == \E p \in workers : finished[p]

aborted[p \in workers] ==   /\ sys[p] = "Working" 
                            /\ sys' = [sys EXCEPT ![p] = "Aborted"]
                            
canAbort == \E p \in workers : aborted[p]

commit ==   /\ sys = Prepared
            /\ sys' = Success
            
     
abortCommit == sys # Success /\ sys # Failure /\ sys' = Failure

Next == \/ canEnd
        \/ canAbort
        \/ commit
        \/ abortCommit
       
Spec == Init /\ [][Next]_<<sys>> /\ WF_<<sys>>(Next)

NoStupidShit == \A w1, w2 \in workers :  ~  /\ sys[w1] = "Commited" 
                                            /\ sys[w2] = "Aborted" 


            

=============================================================================
\* Modification History
\* Last modified Wed May 18 17:44:29 WEST 2022 by k1yps
\* Created Wed May 18 15:00:44 WEST 2022 by k1yps
