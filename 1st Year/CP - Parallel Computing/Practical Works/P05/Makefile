CC = gcc

CCFLAGS = -std=c99 -O2 -fopenmp -Wall -Wextra -lm


default: ex1 ex2 ex3

ex1: ex1.c
	$(CC) $(CCFLAGS) ex1.c -o ex1.out

ex2: ex2.c
	$(CC) $(CCFLAGS) ex2.c -o ex2.out

ex3: ex3.c
	$(CC) $(CCFLAGS) ex3.c -o ex3.out

clean:
	rm -f *.o .a *~ Makefile.bak *.out
