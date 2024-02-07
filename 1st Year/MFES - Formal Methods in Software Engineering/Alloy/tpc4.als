// Mostre como pode usar o Alloy para encontrar um circuito Euleriano num grafo não-orientado e ligado (sem lacetes).

sig Node {
    var edge: set Node, // Grafo Inicial
    var visited: set Node // Circuito Final (Apenas por razões estéticas, pode ser retirado)
}

var one sig CNode in Node {} // Nodo atual

// Condições inciciais do grafo
fact goodGraph {
    all n1,n2 : Node.edge | n1!=n2 => n2 in n1.^(edge) // Grafo é ligado
    edge = ~edge // Grafo não é orientado
    all n : Node | no n->n&edge // Grafo nã́o tem lacetes
}

fact Init { no visited } // Inicialmente nenhum nodo foi visitado

fact findsCircuit { eventually (no edge) } // Eventualmente todos os nodos foram visitados

// Iteração
pred step [e : edge] {
    edge' = edge-e-~e // Retirar a edge do grafo atual
    visited' = visited+e // Adicionar edge ao circuito final
    CNode' = CNode.e // Atualizar o nodo atual
}

// Stuttering
pred nop {
    edge' = edge
    visited' = visited
    CNode' = CNode
}

// A cada iteração o algoritmo ou não faz nada ou escolhe uma aresta existente no grafo atual e ligada ao nodo atual
fact Traces { always (nop or some n : CNode.edge | step[CNode->n]) }

run Exemplo {
    all n : Node | n->(Node-n) in edge // Grafo Completo
} for exactly 5 Node, 20 steps // 5 nodos
