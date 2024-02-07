#!/bin/bash


MY=/home/pg47238/P06/PL06_Codigo

perf record  ./a.out 
perf report -n > perfreport
