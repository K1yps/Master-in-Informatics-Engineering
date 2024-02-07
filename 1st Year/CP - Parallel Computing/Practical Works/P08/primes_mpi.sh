#!/bin/bash
#SBATCH --time=0:20
#SBATCH --ntasks=3
#SBATCH --partition=cpar

mpirun -np 3 ./primes

