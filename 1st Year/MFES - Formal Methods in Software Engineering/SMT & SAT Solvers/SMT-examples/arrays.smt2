(set-logic QF_AUFLIA)

(set-info :source |

====== OBSSERVAÇÔES sobre a modelação lógica de atribuições e arrays =======

As atribuições como x := x + 1 são codificadas criando variáveis (e.g. x0 e x1)
que representam o valor de x antes e depois da atribuição.
A codificação lógica seria neste caso (= x1 (+ x0 1)).

Um acesso ao array a[i] é codificada por (select a i).

A escrita de um valor v na posição i de um array a é representada por
(store a i v). O resultado é um novo array em tudo igual ao primeiro excepto
na posição i que tem agora o valor v.

Note que o array é modelado lógicamente como uma função, pelo que a atribuição
a um array é codificada criando variáveis do tipo array que representam o array
antes e depois da atribuição.
Por exemplo, a[i] := v  é modelada assim: (= a1 (store a0 i v)))

|)


;; ======== PROGRAMA =======
;; x = a[i];
;; y = y + x;
;; a[i] = 5 + a[i];
;; a[i+1] = a[i-1] - 5;


(declare-fun a0 () (Array Int Int))
(declare-const a1 (Array Int Int))   ; outra forma de declarar constantes
(declare-const a2 (Array Int Int))

...