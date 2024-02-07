#include <mpi.h>
#include <stdio.h>


int main( int argc, char *argv[]) {
	int rank, msg, size;
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size );
	MPI_Comm_rank( MPI_COMM_WORLD, &rank ); // gets this process rank
	/* Process 0 sends and Process 1 receives */
	if (rank == 0) {
		msg = 123456;
		printf("Start\n");
		}
	if (rank > 0) {
		MPI_Recv( &msg, 1, MPI_INT, rank-1, 0, MPI_COMM_WORLD, &status );
		printf( "Rank %d : Received %d\n",rank, msg);
		}
	if (rank < size - 1) {
        	MPI_Send( &msg, 1, MPI_INT, rank+1, 0, MPI_COMM_WORLD);
                }
	if (rank == size - 1){
		printf("Fin\n");
		}

	MPI_Finalize();
	return 0;
}
