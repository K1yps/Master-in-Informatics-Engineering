----------------------------- MODULE Exercicio1 -----------------------------
(* Exercicio 1 *)


EXTENDS Naturals

CONSTANT N

ASSUME N > 0

VARIABLE flag, pc

vars == <<flag, pc>>

procs == 1..N

States ==  {"idle", "wait0","check", "wait1", "wait2", "critical"}

(* Alinea b)                                                                    *)
(* Sendo isto um algoritmo imperativo, existe um  estado associado ao    *)
(* sistema que indica qual a proxima opera��o a  executar. Para conseguirmos *)
(* especificar esse estado, � necess�rio definir uma variavel, que neste caso � *)
(* pc, que indica qual a proxima tarefa a ser executada em cada um dos n�s ser� um set *)
(* de procs para o conjunto de todas as opera��es possiveis como � possivel ver  *)
(* na declara��o de TypeOk.                                               *)


TypeOK == flag \in [procs -> 0..4] /\ pc \in [procs -> States]

Init == flag = [w \in procs |-> 0 ] /\ pc = [w \in procs |-> "idle"]


idle(i) ==  /\ flag' = [flag EXCEPT ![i] = 1] 
            /\ pc[i] = "idle" 
            /\ pc' =[pc EXCEPT ![i] = "wait0"]

wait0(i) == /\ pc[i] = "wait0"
            /\ pc' = [pc EXCEPT ![i] ="check"]
            /\ flag \in [procs -> 0..2]
            /\ flag' = [flag EXCEPT ![i] = 3] 
            
            
exists1 == \E k \in procs : flag[k] = 1            
            
check(i) == /\ pc[i] = "check" 
            /\IF exists1 
                THEN /\ flag' = [flag EXCEPT ![i] = 2]
                     /\ pc' = [pc EXCEPT ![i] = "wait1"]
                ELSE /\ flag' = [flag EXCEPT ![i] = 4]
                     /\ pc' = [pc EXCEPT ![i] = "wait2"]

wait1(i) == /\ pc[i] = "wait1" 
            /\ pc' = [pc EXCEPT ![i] = "wait2"]
            /\ flag' = [flag EXCEPT ![i] = 4]
            
            
wait2(i) == /\ pc[i] = "wait2" 
            /\ pc' = [pc EXCEPT ![i] = "critical"]
            /\ \A k \in 1..(i-1) : flag[k] \in {0,1}
            /\ UNCHANGED <<flag>>
            
            
critical(i) == /\ pc[i] = "critical" 
               /\ pc' = [pc EXCEPT ![i] = "idle"]  
               /\ flag \in [procs -> {0, 1, 4}]  
               /\ flag' = [flag EXCEPT ![i] = 0]


Next == \E i \in procs: \/ idle(i)
                        \/ wait0(i)
                        \/ check(i)
                        \/ wait1(i) 
                        \/ wait2(i) 
                        \/ critical(i) 

(*Alinea c*)
(*A exclus�o m�tua � garantida pelo invariante*)
MutualExclusion == \A i1, i2 \in procs : pc[i1] = "critical" /\ pc[i2] = "critical" => i1 = i2

(* Alinea d*)
(* Adicionar esta express�o na especifica��o. Garante weak fairness nas regioes criticas de cada processo*)
WFcritical == \A i \in procs : WF_vars(critical(i))

(* Alinea e*)
(* Quando se tenta provar a propriedade seguinte, o TLA+ mostrar� um contraexemplo com um caminho possivel para este caso *)
alineaE == \E i \in procs: [] ( pc[i] # "critical")


(*Alinea f*)




(*Alinea g*)
(* A propriedade anterior � uma propriedade de liveness pois pretende definir que o sistema garantir� que existir�*)
(* uma distribui��o justa das regi�es criticas, descrevendo a funcionalidade que este tem de ter. Uma propriedade de safety*)
(* prentende antes impedir que ocorram situa��es consideradas erradas ou "m�s", o que n�o � o caso desta propriedade*)


Specs == Init /\ [][Next]_vars /\ WFcritical 







=============================================================================
