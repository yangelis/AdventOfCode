FC       := gfortran
FCFLAGS  := -std=f2008 -ffree-form -Wall -Wextra -Wpedantic -I.. -O3 -ggdb

.PHONY: all
all: day02

aoc.o: ../aoc.f90
	$(FC) $(FCFLAGS) $^ -c

day02 : main.f90 aoc.o
	$(FC) $(FCFLAGS) -o $@ $^

.PHONY: clean
clean:
	rm -f *.o day02 *.mod
