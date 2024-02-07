(set-logic QF_AUFLIA)

; exercício
;; x = a[i];
;; y = y + x;
;; a[i] = 5 + a[i];
;; a[i+1] = a[i-1] - 5;

(declare-const x Int)
(declare-const i Int)
(declare-fun y0 () Int)
(declare-fun y1 () Int)
(declare-const a0 (Array Int Int))
(declare-const a1 (Array Int Int))
(declare-const a2 (Array Int Int))

;; x = a0[i];
(assert (= x (select a0 i)))

;;; y = y + x
(assert (= y1 (+ y0 x)))

;; a1[i] = 5 + a0[i];
(assert (= a1 (store a0 i (+ 5 (select a0 i)))))

;; a2[i+1] = a1[i-1] - 5;
(assert (= a2 (store a1 (+ i 1) (- (select a1 (- i 1)) 5))))

(push)

(echo "----------------")
;; in the pos-state the assertion x+a[i-1] = a[i]+a[i+1] holds?
(assert (not (= (+ x (select a2 (- i 1)))
                (+ (select a2 i) (select a2 (+ i 1))) ) ))

(echo "-- In the pos-state the assertion x+a[i-1] = a[i]+a[i+1] holds?")

(check-sat)
(pop)
(push)

(echo "----------------")
;; in the pos-state a[i-1]+a[i] > 0 holds?

(assert (not (> (+ (select a2 (- i 1)) (select a2 i)) 0)))

(echo "-- In the pos-state a[i-1]+a[i] > 0 holds?")

(check-sat)
(get-model)


(pop)
(push)

(echo "----------------")
;; -- If in the pre-state y<5 then the final value of a[i] is greater that the final value of y.
(assert (not (=> (< y0 5) (> (select a2 i) y1) )))

(echo "-- If in the pre-state y<5 then the final value of a[i] is greater that the final value of y.")

(check-sat)


(exit)

