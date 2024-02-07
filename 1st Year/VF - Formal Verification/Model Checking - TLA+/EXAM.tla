EXTENDS Naturals, Sequences

CONSTANT RING

ASSUME /\ RING \in Seq(Nat)
       /\ \A i1,i2 \in DOMAIN RING : RING[i1] = RING[i2] => i1 = i2

VARIABLES inbox, isLeader

Proc == DOMAIN RING

succ[p \in Proc] == 1 + (p % Len(RING))

TypesOK == /\ inbox \in [ Proc -> SUBSET Nat ]
           /\ isLeader \in [ Proc -> BOOLEAN ]
           
Init == /\ inbox  = [ p \in Proc |-> {} ]
        /\ isLeader = [ p \in Proc |-> FALSE ]
        
SendID(p) == /\ inbox' = [ inbox EXCEPT ![succ[p]] = inbox[succ[p]] \cup {RING[p]} ]
             /\ UNCHANGED isLeader
             
RecvId(p) == \E i \in inbox[p] : \/ /\ i = RING[p]
                                    /\ isLeader' = [ isLeader EXCEPT ![p] = TRUE ]
                                    /\ UNCHANGED inbox
                                 \/ /\ i > RING[p]
                                    /\ inbox' = [ inbox EXCEPT ![succ[p]] = inbox[succ[p]] \cup {i} ]
                                    /\ UNCHANGED isLeader
                                    
Next == \E p \in Proc : SendID(p) \/ RecvId(p)

Spec == Init /\ [] [Next]_<<inbox,isLeader>> /\ WF_<<inbox,isLeader>>(Next)

LeaderElected == \E p \in Proc : isLeader[p] = TRUE

AtMostOneLeader == [] (\A p1, p2 \in Proc : isLeader[p1] /\ isLeader[p2] => p1 = p2)

LeaderDoesntChange == [] (\A p \in Proc : isLeader[p] => [] isLeader[p])

EventualElection == <> LeaderElected  

LeaderHasHighestId == [] \A p \in Proc : isLeader[p] => \A y \in Proc : RING[p] >= RING[y]