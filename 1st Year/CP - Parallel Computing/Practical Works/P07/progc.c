#include <mpi.h>
#include <stdio.h>


int main( int argc, char *argv[]) {
	int rank, msg, size, n = 10;
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size );
	MPI_Comm_rank( MPI_COMM_WORLD, &rank ); // gets this process rank
	/* Process 0 sends and Process 1 receives */
	if (rank == 0) {
		printf("Start\n");
		while ( n > 0){
			msg = n;
        		MPI_Send( &msg, 1, MPI_INT, 1, n, MPI_COMM_WORLD);
			n--;
			}
		}
	if (rank > 0 && rank < size - 1) {
		int prev = rank-1, next = rank + 1;
		while (n > 0){
			MPI_Recv( &msg, 1, MPI_INT, prev, n, MPI_COMM_WORLD, &status );
			printf( "Rank %d : Received %d\n",rank, msg);
        		MPI_Send( &msg, 1, MPI_INT, next, n, MPI_COMM_WORLD);
			n--;			
			}                
		}
	if (rank == size - 1){
		int prev = rank - 1;
		while ( n > 0 ){
			MPI_Recv( &msg, 1, MPI_INT, prev, n, MPI_COMM_WORLD, &status );			
			printf( "Rank %d : Received %d\n",rank, msg);
			n--;
		}
		printf("Fin\n");
		}
	MPI_Finalize();
	return 0;
}
