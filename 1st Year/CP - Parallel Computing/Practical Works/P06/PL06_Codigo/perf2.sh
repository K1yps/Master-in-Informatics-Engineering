#!/bin/bash


MY=/home/pg47238/P06/PL06_Codigo


perf record  $MY/sort  10000000
perf report  -n > perfreport
