//#include <mpi.h>
#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>

#include"PrimeServer.cpp"

// place number on buf (exclude evens)
void generate(int min, int max, int* buf) {
  int j=0;
  for(int i=min; i<max; i+=2) {
    buf[j++]=i;
  }
}

int main(int argc, char **argv) {
    int nprocesses;
    int myrank;
    
    int NMSG = 10
    int MAXP = 1000000; // maximum prime to compute
    int SMAXP = 1000;   // square root of max prime
    int pack=MAXP/NMSG;   // process "pack" of numbers (subset of #messages)
    int size, rank;

    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size );
    MPI_Comm_rank( MPI_COMM_WORLD, &rank ); // gets this process rank    
    
    PrimeServer *ps = new PrimeServer();    
    ps->initFilter(rank * (SMAXP/size) + 1, (rank+1) * SMAXP/size,SMAXP);
    
    int *ar = new int[pack/(2 * size)];  // alocate space (exclude evens)
    
    for(int i=0; i<NMSG; i++) {   // sends a total of 10 messages
	if (rank == 0 )
            generate(i*pack, (i+1)*pack, ar);  // place numbers on ar
	else
	    MPI_Recv( &ar, i * pack , MPI_INT , rank-1, i, MPI_COMM_WORLD, &status );    	    
		ps->mprocess(ar,pack/2);  // remove non-primes (1st 1/3)
	}
    }
    
   


    if (rank+1 == size)
    	ps->end(); // show statistics (on last filter)
    
    MPI_Finalize();
    return(0);
}
