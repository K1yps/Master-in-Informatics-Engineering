#include<omp.h>
#include<stdio.h>

int main() {
	printf("master thread\n");
	#pragma omp parallel for schedule(dynamic, 10) num_threads(4)
	for(int i=0;i<100;i++) {
		int id = omp_get_thread_num();
		printf("T%d:i%d\n", id, i);
	}
	printf("master thread\n");
}
