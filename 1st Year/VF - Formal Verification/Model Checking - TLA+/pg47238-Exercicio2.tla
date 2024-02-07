----------------------------- MODULE Exercicio2 -----------------------------
(* Exercicio 2 *)
(* Henrique Gabriel dos Santos Neto*)
(* PG47238 *)

EXTENDS Naturals, Sequences

CONSTANTS V, N

ASSUME /\ V>0
       /\ N> 0

VARIABLES channel


(* Alinea b*)
(* Este invariante TypeOK garante o canal nunca � invalido nem possui valores invalidos *)
TypeOK == /\ channel \in Seq(0..V)
          /\ Len(channel) =<N
    
    
Init == channel = <<>>      
          
send[msg \in 0..V] == \/ /\ Len(channel) = N
                         /\ channel' = Tail(channel) \o <<msg>> 
                      \/ /\ Len(channel) < N
                         /\ channel' = channel \o <<msg>> 
            
recv == /\ Len(channel) > 0
         /\ channel' = Tail(channel) 
        
        
Next == \/ \E msg \in 0..V : send[msg]
        \/ recv


Spec == Init /\ [][Next]_<<channel>>


(*Alinea c*)
(* Ao testar se a propriedade seguinte, esta ser� � falsa e o IDE devolver� um contraexemplo de um caso possivel*)
FullThenNotEmpty == []((Len(channel) = N) => [](Len(channel) > 0))


(*Alinea d*)
(* O sistema j� garante isto por si s�. Podemos especificar uma propriedade que verifica*)
(* que o sistema nao pode receber msgs se estas nao existirem que j� est� implicido no modelo*)
OnlyValidMsg == ENABLED(recv) => Len(channel) > 0


(*Alinea e*)
NoMsgEnventualyEmpty == <> (([] ~ (\A i \in 0..V:  ENABLED(send[i]))) ~> Len(channel) = 0 )






=============================================================================
\* Modification History
\* Last modified Fri May 20 11:41:10 WEST 2022 by k1yps
\* Created Fri May 20 09:45:46 WEST 2022 by k1yps
