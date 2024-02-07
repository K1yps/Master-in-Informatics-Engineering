sig Node {
	// As arestas do grafo
	edge : set Node,
	// O caminho eulariano
	var path : set Node,
	// Arestas que ainda não foram atravessadas pelo caminho eulariano
	var available : set Node
}

one var sig Active in Node {}

fact Init {
	Invariants[]
	available = edge
	no path
}

pred Invariants {
	// O grafo não tem lacetes
	no edge & iden
	// As arestas não são orientadas (i.e. são bidirecionais)
	all n0,n1 : Node | n1 in n0.edge implies n0 in n1.edge
	// O grafo é ligado
	all n : Node | Node in n.^(edge) + n
	// O grafo é euleriano (i.e. o grau de cada vertice é par)
	all n : Node | rem[#n.edge,2] = 0
	// As arestas de um caminho são válidas
	no path - edge
}

pred End {
	// In the end there every edge has been accounted for
	no available
	// The state remains the same
	edge' = edge
	available' = available
	path' = path
	available'= available
	Active' = Active
}

pred Euler [active : Node] {
		active = Active
		edge' = edge

		one next : active.available |
			path' = path + active->next
			and Active' = next
			and available'= available - ( active->next + next->active )
}

pred Grafo_Completo {
	all n : Node | Node in n.edge + n
}

fact Traces {
	always Invariants[]
	always (
		End or
		some n : Node | Euler[n]
	)
}

run Cinco_Nos {} for exactly 5 Node

run GrafoCompleto{
	Grafo_Completo
} for exactly 5 Node, 20 steps
