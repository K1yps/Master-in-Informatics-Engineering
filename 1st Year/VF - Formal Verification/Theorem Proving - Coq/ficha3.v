Require Import ZArith.

Require Import List.

Require Import Lia.
Require Extraction.
Extraction Language Haskell.

Set Implicit Arguments.

(* Exercicio 5 *)

Inductive ListBuild (A:Type) : A -> nat -> list A -> Prop :=
| listBuild_base : forall (x:A), ListBuild x 0 nil
| listBuild_step : forall x n l, ListBuild x n l -> ListBuild x (S n) (cons x l).

Theorem ListBuild_correct: forall (A:Type) (x:A) (n:nat), {l : list A | ListBuild x n l}.
Proof.
  intros.
  induction n.
  - exists nil. constructor.
  - destruct IHn. exists (x::x0). constructor. assumption.
Qed.

Recursive Extraction ListBuild_correct.

Extraction False_rect.
Extraction Inline False_rect.  (* will make the code more readable *)
Extraction head.

Recursive Extraction ListBuild_correct.


Inductive SumPairList: list (nat*nat) -> list nat -> Prop:=
| SumPairList_base : SumPairList nil nil
| SumPairList_step : forall (pair: nat*nat) (pair_list: list (nat*nat)) (sum_list: list nat), SumPairList (pair_list) sum_list -> SumPairList (pair::pair_list) (fst (pair) + snd (pair)::sum_list).


Theorem sumPairList_correct: forall (pair_list:list (nat*nat)), {sum_list: list nat | SumPairList pair_list sum_list}.
Proof.
  intros.
  induction pair_list.
  - exists nil. constructor.
  - destruct IHpair_list. exists (((fst a) + (snd a))::x). constructor. assumption.
Qed.

Recursive Extraction sumPairList_correct.

Extraction False_rect.
Extraction Inline False_rect.  (* will make the code more readable *)
Extraction head.

Recursive Extraction sumPairList_correct.

(* Exercicio 5 a*)

Fixpoint count (z:Z) (l:list Z) {struct l} : nat :=
  match l with
  | nil => 0%nat     
  | (z' :: l') => if Z.eq_dec z z' 
                  then S (count z l')
                  else count z l'
  end.

Lemma prop_a: forall (x:Z) (a:Z) (l:list Z), x <> a -> count x (a :: l) = count x l.
Proof.
  intros.
  induction l.
  * simpl. elim (Z.eq_dec x a).
    -- contradiction.
    -- trivial.
  * simpl. elim (Z.eq_dec x a). intros. 
    -- contradiction. 
    -- intro. elim (Z.eq_dec x a0). 
      ** intro. reflexivity.
      ** intro. reflexivity.
Qed.

(* Exercicio 5 b*)

Inductive count_ind: Z -> list Z -> nat -> Prop :=
| count_ind_base : forall z:Z, count_ind z nil 0
| count_ind_step1 : forall (z:Z) (l:list Z) (n:nat), count_ind z l n -> count_ind z (z::l) (S n)
| count_ind_step2 : forall (z:Z) (l:list Z) (n:nat) (a:Z), z <> a -> count_ind z l n -> count_ind z (a::l) n.

(* Exercicio 5 c*)

Lemma prop_c: forall (x:Z) (l:list Z), count_ind x l (count x l).
Proof.
  intros.
  induction l.
  - unfold count. constructor.
  - simpl. elim (Z.eq_dec x a).
    ** intro. rewrite <- a0. constructor. assumption.
    ** intros. constructor. 
      -- assumption.
      -- assumption.      
Qed.




