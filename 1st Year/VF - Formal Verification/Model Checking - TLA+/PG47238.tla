------------------------------ MODULE PG47238 ------------------------------


(* Exercicio 1 *)

(* b)                                                                    *)
(* Sendo isto um algoritmo imperativo, existe um  estado associado ao    *)
(* sistema que indica qual a proxima operação a  executar. Para conseguirmos *)
(* especificar esse estado, é necessário definir um variavel, que neste caso é *)
(* pc, que indica qual a proxima tarefa a executar e que desta forma fará *)
(* parte do conjunto de todas as operações possiveis como é possivel ver  *)
(* na declaração de TypeOk.                                               *)


EXTENDS Naturals

CONSTANT N

ASSUME N > 0

VARIABLE flag, pc

vars == <<flag, pc>>

procs == 1..N

TypeOK == flag \in [procs -> 0..3] /\ pc \in {"idle", "wait0","check", "wait1", "wait2", "critical"}

Init == flag = [procs -> 0 ]


idle(i) == flag' = [flag EXCEPT ![i] = 1] /\ pc = "idle" /\ pc' = "wait0"

wait0(i) == /\ pc = "wait0"
            /\ pc' = "check"
            /\ flag \in [procs -> 0..2]
            /\ flag' = [flag EXCEPT ![i] = 3] 
            
            
exists1 == \E k \in procs : flag[k] = 1            
            
check(i) == /\ pc = "check" 
            /\IF exists1 
                THEN /\ flag' = [flag EXCEPT ![i] = 2]
                     /\ pc' = "wait1"
                ELSE /\ flag' = [flag EXCEPT ![i] = 4]
                     /\ pc' = "wait2"

wait1(i) == /\ pc = "wait1" 
            /\ pc' = "wait2"
            /\ flag' = [flag EXCEPT ![i] = 4]
            
            
wait2(i) == /\ pc = "wait2" 
            /\ pc' = "critical"
            /\ flag \in [procs -> 0..1]
            /\ UNCHANGED <<flag>>
            
            
critical(i) == /\ pc = "critical" 
               /\ pc' = "idle"     
               /\ flag \in [procs -> {0, 1, 4}]  
               /\ flag' = [flag EXCEPT ![i] = 0]


Next == \E i \in procs: \/ idle(i)
                        \/ wait0(i)
                        \/ check(i)
                        \/ wait1(i) 
                        \/ wait2(i) 
                        \/ critical(i) 


Specs == Init /\ [][Next]_vars 


=============================================================================
\* Modification History
\* Last modified Fri May 20 09:44:52 WEST 2022 by k1yps
\* Created Fri May 20 09:02:31 WEST 2022 by k1yps
