-------------------------------- MODULE Pet --------------------------------

VARIABLES flag0, flag1, turn, pc0, pc1

vars == << flag0, flag1, turn, pc0, pc1 >>

Init ==  flag0 = FALSE /\ flag1 = FALSE /\ turn \in {0,1} /\ pc0 = "idle" /\ pc1= "idle"


ask0 == pc0 = "idle" /\ flag0' = TRUE /\ turn' = 1 /\ pc0' = "wait" /\ UNCHANGED << flag1, pc1 >>

ask1 == pc1 = "idle" /\ flag1' = TRUE /\ turn' = 0 /\ pc1' = "wait" /\ UNCHANGED << flag0, pc0 >>

enter0 == pc0 = "wait" /\ ~(flag1 /\ turn = 1) /\ pc0' = "critical" /\ UNCHANGED << flag0, flag1, turn, pc1 >>

enter1 == pc1 = "wait" /\ ~(flag0 /\ turn = 0) /\ pc1' = "critical" /\ UNCHANGED << flag0, flag1, turn, pc0 >>

exit0 == pc0 = "critical" /\ flag0' = FALSE /\ pc0' = "idle" /\ UNCHANGED << flag1, turn , pc1 >>

exit1 == pc1 = "critical" /\ flag1' = FALSE /\ pc1' = "idle" /\ UNCHANGED << flag0, turn , pc0 >>


Next == ask0 \/ ask1 \/ enter0 \/ enter1 \/ exit0 \/ exit1

Spec == Init /\ [][Next]_vars


TypesOK == 
    /\ flag0 \in {TRUE , FALSE}
    /\ flag1 \in {TRUE , FALSE}
    /\ turn \in {0,1}
    /\ pc0 \in {"idle","critical","wait"}
    /\ pc1 \in {"idle","critical","wait"}


MutualExclusion == [] ~(pc0="critical" /\ pc1="critical")

LockFreadom == [] (pc0 = "wait" => <> (pc0="critical")) /\ (pc1="wait" => pc1="critical")


 

=============================================================================
\* Modification History
\* Last modified Fri Apr 29 11:37:03 WEST 2022 by k1yps
\* Created Fri Apr 29 10:30:51 WEST 2022 by k1yps
