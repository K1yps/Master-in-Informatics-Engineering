sig Node {
	var edge : set Node,
	var path : set Node,
	var available : set Node
}

var sig Active in Node {}

pred Invariants {
	// O grafo não tem lacetes
	no edge & iden
	// As arestas não são orientadas (i.e. são bidirecionais)
	all n0,n1 : Node | n1 in n0.edge implies n0 in n1.edge
	// O grafo é ligado
	all n : Node | Node in n.^(edge) + n
	// O grafo é euleriano (i.e. o grau de cada vertice é par)
	all n : Node | rem[#n.edge,2]=0
	// As arestas de um caminho são válidas
	no path - edge
}

fact Init {
	Invariants[]
	available = edge
	no path
}

pred End {
	no available
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

// ----------------------------------------------------

fact Traces {
	always Invariants[]
	always (
		End or
		some n : Node | Euler[n]
	)
}

run Cinco_Nos {} for exactly 5 Node

run Grafo_Completo{
	all n : Node | Node in n.edge + n
}
