#!/bin/bash


MY=/home/pg47238/P06/PL06_Codigo
SORT_SIZE=10000000


export OMP_NUM_THREADS=2
$MY/sort  $SORT_SIZE
export OMP_NUM_THREADS=4
$MY/sort  $SORT_SIZE
export OMP_NUM_THREADS=8
$MY/sort  $SORT_SIZE
