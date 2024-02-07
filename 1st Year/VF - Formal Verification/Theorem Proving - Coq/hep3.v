


(* Secção 4 *)


Fixpoint split (A:Type) (l:list A) : (list A * list A) :=
match l with
| [] => ([],[]) (* Import ListNotations. *)
| [x] => ([x],[])
| x1::x2::l' => let (l1,l2) := split l' in (x1::l1,x2::l2)
end.


Lemma ex1 :forall (A:Type) (l l1 l2: list A),
split l = (l1,l2) -> length l1 <= length l /\ length l2 <= length l.