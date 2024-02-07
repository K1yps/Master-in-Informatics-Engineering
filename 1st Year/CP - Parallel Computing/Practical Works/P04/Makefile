
NAME = ex41

CC = gcc

CCFLAGS = -std=c99 -O2 -fopenmp


default: ex41 ex42 ex43 ex44

ex41: ex41.c
	 $(CC) $(CCFLAGS) ex41.c -o ex41.out

ex42: ex42.c
	$(CC) $(CCFLAGS) ex42.c -o ex42.out

ex43: ex43.c
	$(CC) $(CCFLAGS) ex43.c -o ex43.out

ex44: ex44.c
	$(CC) $(CCFLAGS) ex44.c -o ex44.out


clean:
	rm -f *.o .a *~ Makefile.bak *.out
