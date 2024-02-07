#include<omp.h>
#include<stdio.h>

int main() {
	printf("master thread\n");
	#pragma omp parallel for ordered num_threads(4)
	for(int i=0;i<100;i++) {
		int id = omp_get_thread_num();		
		#pragma omp ordered
		printf("T%d:i%d\n", id, i);
	}
	printf("master thread\n");
}
