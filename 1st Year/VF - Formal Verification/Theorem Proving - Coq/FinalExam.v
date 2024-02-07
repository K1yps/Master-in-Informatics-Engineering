

Set Implicit Arguments.


Require Import List.
Require Import ZArith.
Require Import Lia.



Section Parte1.
(* Prove os lemas desta secção SEM usar táticas automáticas *)

Variables A B C D : Prop.
Variable X : Set.
Variables P W Q : X -> Prop.


Lemma questao1 : (A->B) /\ (C->D) -> (A\/C) -> (B\/D).
Proof.
  intros.
  destruct H.
  destruct H0.
  - left. apply H. assumption.
  - right. apply H1. assumption.
Qed.


Lemma questao2 : (A /\ B) -> ~(~A \/ ~B).
Proof.
  intros.
  intro.
  destruct H.
  destruct H0.
  - contradiction.
  - contradiction.
Qed.

Lemma questao3 : (forall x:X, (P x) -> (Q x)) -> (forall y:X, ~(Q y)) -> (forall x:X, ~(P x)).
Proof.
  intros.
  intro.
  assert (Q x).
  - apply H. assumption.
  - generalize H2. apply H0.
Qed.


Lemma questao4 :  (forall z:X, (P z)-> (W z)) -> (exists x:X, (P x)/\(Q x)) -> (exists y:X, (W y)/\(Q y)).
Proof.
  intros H H0.
  destruct H0 as [x H1].
  destruct H1.
  exists x.
  split.
  - apply H. assumption.
  - assumption.  
Qed.


Lemma questao5 : forall (x y:nat), x + 3 = y -> x < y.
Proof.
  intros.
  rewrite <- H .
  apply Nat.lt_add_pos_r.
  apply Nat.lt_0_succ.
Qed.

End Parte1.




Open Scope Z_scope.


Section Parte2.
(* ================================================================== *)
(* Prove os lemas desta secção. Pode usar táticas automáticas.        *)
(* Se precisar de definir lemas auxiliares, deverá também prova-los.  *)


Inductive In (A:Type) (y:A) : list A -> Prop :=
| InHead : forall (xs:list A), In y (cons y xs)
| InTail : forall (x:A) (xs:list A), In y xs -> In y (cons x xs).


Inductive Suffix (A:Type) : list A -> list A -> Prop :=
| Suf0 : forall (l:list A), Suffix nil l
| Suf1 : forall (x:A) (l1 l2:list A), Suffix l1 l2 -> Suffix (x::l1) (x::l2)
| Suf2 : forall (x:A) (l1 l2:list A), Suffix l1 l2 -> Suffix (l1) (x::l2).


Inductive NInferiores (x:Z) : list Z -> Prop :=
| NInf_nil : NInferiores x nil
| NInf_cons : forall (l:list Z) (y:Z), y >= x -> NInferiores x l -> NInferiores x (y::l).


Fixpoint drop (A:Type)(n:nat) (l:list A) : list A :=
  match n with
  | O => l
  | S x => match l with
           | nil => nil
           | y::ys => drop x ys
           end
  end.

Fixpoint delete (x:Z) (l:list Z)  : list Z :=
  match l with
  | nil => nil
  | (h :: t) => if (Z.eq_dec x h) then t else h :: delete x t
  end.


(* Adicionado pelo aluno *)
Lemma In_cons : forall (A:Type) (a b : A) (l : list A), In b (a :: l) -> a = b \/ In b l.
Proof.  
  intros.
  inversion H.
  - left. reflexivity.
  - right; assumption.
Qed.



Lemma questao6 : forall (A:Type) (l:list A),  drop (length l) l = nil.
Proof.
  intros.
  induction l.
  - simpl. reflexivity.
  - simpl. assumption.
Qed.


Lemma questao7 : forall (A: Type) (x: A) (l: list A),
         In x l ->  exists l1: list A, exists l2: list A, l = l1 ++ (x :: l2).
Proof.
  intros.  
  induction l.
  - inversion H.
  - apply In_cons in H.
    destruct H.
    + rewrite H. exists nil. exists l. reflexivity.
    + apply IHl in H. destruct H. destruct H. exists (a::x0). exists x1. rewrite H. reflexivity.
Qed.

Lemma questao8 : forall (x:Z) (l1 l2:list Z),  NInferiores x l2 /\ Suffix l1 l2 -> NInferiores x l1.
Proof.
  intros.
  destruct H.
  induction H. 
    - induction l1.
      + constructor.
      + inversion H0.
    - apply IHNInferiores.
    
Admitted.
(*Incomplete*)



Lemma questao9 : forall (x:Z) (l:list Z), In x l -> (length (delete x l) < length l)%nat.
Proof.
  intros.
  induction l.
  - inversion H.
  - simpl. destruct (Z.eq_dec x a).
    + lia.
    + simpl. apply lt_n_S. apply IHl. apply In_cons in H. destruct H.
      * symmetry in H. contradiction.
      * assumption.
Qed.

End Parte2.




Close Scope Z_scope.



Section Parte3.
(* ================================================================== *)
(* Considere as funções abaixo definidas e prove o teorema.           *)
(* Pode usar táticas automáticas.                                     *)
(* Se precisar de definir lemas auxiliares, deverá também prova-los.  *)



Fixpoint numOc (a:nat) (l: list (nat*nat)) : nat :=
  match l with
  | nil => 0 
  | ((x,n)::xs) => if (Nat.eq_dec a x) then n else numOc a xs
  end.


Fixpoint insN (a n:nat) (l: list (nat*nat)) : list (nat*nat) :=
  match l with
  | nil => (a,n)::nil
  | ((x,n1)::xs) => if (Nat.eq_dec a x)
                    then (x,n+n1)::xs
                    else (x,n1) :: insN a n xs
  end.                                                         


Theorem questao10 : forall x n l, (n <= numOc x (insN x n l))%nat.
Proof.
  intros.
  induction l.
    - simpl. elim (Nat.eq_dec x x).
      + intro. lia.
      + intro. lia.
    - elim a. intros.
      simpl. elim (Nat.eq_dec x a0).
      + intros. simpl. elim (Nat.eq_dec x a0).
        * intro. lia.
        * intros. contradiction.
      + intros. simpl. elim (Nat.eq_dec x a0).
        * intros. lia.
        * intros. lia.
Qed.

End Parte3.
