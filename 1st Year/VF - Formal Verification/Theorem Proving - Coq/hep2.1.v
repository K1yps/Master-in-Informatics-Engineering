Require Import List.

Set Implicit Arguments.

(* Secção 3 *)

(* Definição de sum *)
Fixpoint sum (l: list nat): nat :=
  match l with
  | nil => 0
  | cons x y => x + sum y
  end.

(* 3.1 *)
Lemma ex1: forall l1 l2, sum (l1 ++ l2) = sum l1 + sum l2.
Proof.
  intros.
  induction l1.
  - simpl. reflexivity.
  - simpl. rewrite IHl1. 
    SearchRewrite (_ + (_ + _)).
    rewrite PeanoNat.Nat.add_assoc.
    reflexivity.
Qed.

(* 3.2 *)
Lemma ex2 : forall (A:Type) (l:list A), length (rev l) = length l.
Proof.
  intros.
  induction l.
  - simpl. reflexivity.
  - simpl. 
    Search length.  (* How i found out what to use*)
    rewrite last_length. 
    Search  (S _ = S _ ). (* How i found out what to use*)
    apply eq_S.
    rewrite IHl. reflexivity.
Qed.

(* 3.3 *)
Lemma ex3 : forall (A B:Type) (f:A->B) (l:list A), rev (map f l) = map f (rev l).
Proof.
  intros.
  induction l.
  - simpl. reflexivity.
  - simpl. Search map. rewrite map_app.
    simpl. Search ( _ ++ _ = _ ++ _ ). rewrite app_inv_tail_iff.
    rewrite IHl. reflexivity.
Qed.

(* Secção 4 *)

Inductive In (A:Type) (y:A) : list A -> Prop :=
| InHead : forall xs:list A, In y (cons y xs)
| InTail : forall (x:A) (xs:list A), In y xs -> In y (cons x xs).

(* 4.1 *)
Lemma ex4 : forall (A:Type) (a b : A) (l : list A), In b (a :: l) -> a = b \/ In b l.
Proof.  
  intros.
  inversion H.
  - left. reflexivity.
  - right; assumption.
Qed.

(* 4.2 *)
Lemma ex5: forall (A:Type) (l1 l2: list A) (x:A), In x l1 \/ In x l2 -> In x (l1 ++ l2).
Proof.
  intros.
  destruct H.
  - induction H.
    + constructor.
    + constructor. assumption.
  - induction l1.
    + simpl. assumption.
    + constructor. assumption.
Qed.


(* 4.3 *)
Lemma ex6: forall (A:Type) (x:A) (l:list A), In x l -> In x (rev l).
Proof.
  intros.
  induction l.
  - simpl. assumption.
  - simpl. apply ex5. inversion_clear H.
    * right. constructor.
    * left. apply IHl. assumption.
Qed.


(* 4.4 *)
Lemma ex7:forall (A B:Type) (y:B) (f:A->B) (l:list A), In y (map f l) -> exists x, In x l /\ y = f x.
Proof.
 intros.
 induction l.
  - inversion H.
  - simpl in H. apply ex4 in H. 
    destruct H.
    + exists a. split.
      * constructor.
      * auto.
    + apply IHl in H. destruct H. destruct H. exists x. split.
      * apply InTail. assumption.
      * assumption.
Qed.

(* Secção 5*)

Inductive Prefix (A:Type) : list A -> list A -> Prop :=
| PreNil : forall l:list A, Prefix nil l
| PreCons : forall (x:A) (l1 l2:list A), Prefix l1 l2 -> Prefix (x::l1) (x::l2).


(* 5.1 *)
Lemma ex8: forall (A:Type) (l1 l2:list A), Prefix l1 l2 -> length l1 <= length l2.
Proof.
  intros.
  induction H.
  - induction l.
    + reflexivity.
    + rewrite IHl. simpl. Search ( _ <= S _). apply PeanoNat.Nat.le_succ_diag_r.
  - simpl. Search ( S _ <= S _). apply le_n_S. assumption.
Qed.


(* 5.2 *)
Lemma ex9: forall l1 l2, Prefix l1 l2 -> sum l1 <= sum l2.
Proof.
  intros.
  induction H.
  - simpl. apply PeanoNat.Nat.le_0_l.
  - simpl. Search (_ + _ <= _ + _). apply PeanoNat.Nat.add_le_mono_l. (* auto. tb da acho eu*)
    rewrite IHPrefix. reflexivity.
Qed.


(* 5.3 *)
Lemma ex10: forall (A:Type) (l1 l2:list A) (x:A), (In x l1) /\ (Prefix l1 l2) -> In x l2.
Proof.
  intros.
  destruct H.
  induction H0.
  - induction l. 
    + assumption. 
    + apply InTail. assumption.
  - apply ex4 in H.
    destruct H.
    + rewrite H. constructor. (* constructor aka InHead*)
    + constructor. auto. (* constructor aka InTail*)
Qed.


(* Secção 6 *)

Inductive SubList (A:Type) : list A -> list A -> Prop :=
| SLnil : forall l:list A, SubList nil l
| SLcons1 : forall (x:A) (l1 l2:list A), SubList l1 l2 -> SubList (x::l1) (x::l2)
| SLcons2 : forall (x:A) (l1 l2:list A), SubList l1 l2 -> SubList l1 (x::l2).


(* 6.1 *)
Lemma ex11: SubList (1::3::nil) (3::1::2::3::4::nil).
Proof.
  apply SLcons2. apply SLcons1. apply SLcons2. apply SLcons1. apply SLnil.
  (* 
  Se nao quiserem fazer a dry run, o que tá seguir faz o msm so que automaticamente.
  repeat (constructor). 
  *)
Qed.


(* 6.2 *)
Lemma ex12: forall (A:Type)(l1 l2 l3 l4:list A), SubList l1 l2 -> SubList l3 l4 -> SubList (l1++l3) (l2++l4).
Proof.
  intros.
  induction H.
  - induction l.
    + simpl. assumption.
    + simpl. simpl in IHl. constructor. assumption.
  - simpl. constructor. assumption.
  - simpl. constructor. assumption.
Qed.

(* 6.3 *)
Lemma ex13: forall (A:Type) (l1 l2:list A), SubList l1 l2 -> SubList (rev l1) (rev l2).
Proof.
  intros.
  induction H.
  - apply SLnil.
  - simpl. 
    apply ex12. 
    + assumption.
    + apply SLcons1.
    apply SLnil.
  - simpl. rewrite app_nil_end at 1. (* sem o 'at 1' ele acrescenta o nil no 2ª parametro em vez do 1º*)
    apply ex12.
      + assumption.
      + apply SLnil.
Qed.

(* 6.4 *)
Lemma ex14: forall (A:Type) (x:A) (l1 l2:list A), SubList l1 l2 -> In x l1 -> In x l2.
Proof.
  intros.
  induction H.
  - inversion H0.
  - apply ex4 in H0.
    destruct H0.
    + rewrite H0. constructor.
    + constructor. apply IHSubList. assumption.
  - constructor. apply IHSubList. assumption.
Qed.
