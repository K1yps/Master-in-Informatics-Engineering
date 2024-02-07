#!/bin/bash


MY=/home/pg47238/P06/PL06_Codigo
SORT_SIZE=100000

module load papi/5.4.1
$MY/sort  $SORT_SIZE
