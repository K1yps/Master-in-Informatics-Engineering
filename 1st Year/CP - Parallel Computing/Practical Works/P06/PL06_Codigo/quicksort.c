#include <stdio.h>
#include "quicksort.h"

void partition(float*arr, int *i, int *j);
void quickSort_internel(float* arr, int left, int right) ;

void quickSort(float* arr, int size) 
{

	int i = 0, j = size;
  	/* PARTITION PART */
        partition(arr, &i, &j);

	if (0 < j){ 
        	quickSort_internel(arr, 0, j);
    	}
	if (i< size){
        	quickSort_internel(arr, i, size);
	}
}

void partition(float*arr, int *i, int *j){
	//float pivot = arr[((*j)+(*i)) / 2];
	float pivot = arr[(*j)];
	while ((*i) <= (*j)) {
		while (arr[(*i)] < pivot)
			(*i)++;
		while (arr[(*j)] > pivot)
			(*j)--;
		if ((*i) <= (*j)) {
			float tmp = arr[(*i)];
			arr[(*i)] = arr[(*j)];
			arr[(*j)] = tmp;
			(*i)++;
			(*j)--;
		}
	}
}

void partition_internel(float*arr, int *i, int *j){
	//float pivot = arr[((*j)+(*i)) / 2];
	float pivot = arr[(*j)];
	while ((*i) <= (*j)) {
		while (arr[(*i)] < pivot)
			(*i)++;
		while (arr[(*j)] > pivot)
			(*j)--;
		if ((*i) <= (*j)) {
			float tmp = arr[(*i)];
			arr[(*i)] = arr[(*j)];
			arr[(*j)] = tmp;
			(*i)++;
			(*j)--;
		}
	}
}

void quickSort_internel(float* arr, int left, int right) 
{
	int i = left, j = right;
  	/* PARTITION PART */
        partition_internel(arr, &i, &j) ;

	#pragma omp parallel
	#pragma omp single
	{
	/* RECURSION PART */
	if (left < j){ 
		#pragma omp task
        	quickSort_internel(arr, left, j);
    	}
	if (i< right){
		#pragma omp task
        	quickSort_internel(arr, i, right);
    	}
	}
}
