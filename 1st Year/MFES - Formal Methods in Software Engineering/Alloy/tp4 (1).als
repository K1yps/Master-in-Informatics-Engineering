sig Node {
	connects : set Node,
	var connects_aux : set Node,
	var euler : set Node
}

var sig Current in Node {}

fact {
	//tem de existir pelo menos 1 nodo
	some Node

	//um nodo nao pode estar conectado a si próprio
	no connects & iden
 	
	//de modo a ser um grafo não orientado, se existe uma conexao de x para y, entao
 	// tambem tem de existir uma ligacao de y para x
	all x,y : Node | y in x.connects implies x in y.connects


 	// o grafo tem de ser ligado (existir caminho para todos os vértices
	all x,y : Node | y in x.^(connects)

	// para o grafo poder ter um caminho euleriano todos os nodos têm de ter
	// um numero par de arestas
	all x : Node | rem[#x.connects,2]=0
	
	
}



fact init {
	no euler
	connects_aux = connects
	no Current
}

fact Traces {
	always (
		stutter or
		some n : Node | firstEuler[n] or
		some n : Node | nextEuler[n]
	)
}

pred stutter {
	//guards
	//o algoritmo termina quando o caminho euleriano inclui todas as arestas do grafo
	no connects_aux

	//frame conditions
	euler' = euler
	connects_aux'= connects_aux
	Current' = Current
}


pred firstEuler [n : Node] {
	//guards
	no euler
	
	//effects
	one p : n.connects_aux | 
	euler' = euler + n->p and
	Current' = p
	and connects_aux' = connects_aux - (n->p + p->n)
	}

pred nextEuler [n : Node] {
		n = Current

		one p : n.connects_aux |
		euler' = euler + n->p
		and Current' = p
		and connects_aux'= connects_aux-(n->p + p->n)
}



run {} for exactly 5 Node
