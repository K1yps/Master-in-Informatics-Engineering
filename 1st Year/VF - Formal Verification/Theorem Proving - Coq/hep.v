
Section FDS.

Variable A B C D: Prop.
Variables (P : A->Prop).

Goal (A \/ B) \/ C -> A \/ (B \/ C).
Proof.
  intros.
  destruct H.
  destruct H.
  -left. assumption.
  -right. left. assumption.
  -right; right; assumption.
Qed.


Lemma try_1: (A \/ B) /\ (A \/ C) <-> A \/ (B /\ C).
Proof.
  split.
    - intros. destruct H. destruct H.
      + left;assumption. +destruct H0. 
        * left; assumption.
        * right. split. assumption. assumption.
    - intros. split. destruct H. 
      + left. assumption. 
      + right. destruct H. assumption. 
      + destruct H.
        * left; assumption. 
        * right. destruct H. assumption.
Qed.




Goal (A \/ B) /\ (A \/ C) <-> A \/ (B /\ C).
Proof.
  intuition.
Qed.



Axiom terceiroExclusivo: forall A :Prop, A \/ ~A.
Axiom terceiroExclusivo2: forall A:Prop, ~(A /\ ~A).

Lemma ec1 : ((C -> D) -> C) -> C.
Proof.
 intro.
 destruct terceiroExclusivo with C.
 *assumption.
 *apply H. intro. contradiction.
Qed.

Goal ((A -> B )-> A) -> A.
Proof.
  intro.
  destruct terceiroExclusivo with A.
  - assumption.
  - apply H. intro. contradiction.
Qed. 

Section FDS_2.

Variable X :Set.
Variable t :X. 
Variables P Q : X -> Prop.

Lemma ex36: (exists x, P x) \/ (exists x, Q x) <-> (exists x, P x \/ Q x).
Proof.
  split.
  - intros.
    destruct H as [H1| H2].
    + destruct H1. exists x. left; assumption.
    + destruct H2. exists x. right; assumption.
  - intros.
    destruct H as [x H].
    destruct H.
    + left. exists x. assumption.
    + right. exists x. assumption.
Qed.
    



 