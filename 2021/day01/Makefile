FC       := gfortran
FCFLAGS  := -std=f2008 -ffree-form -Wall -Wextra -Wpedantic -I.. -O0 -ggdb


.PHONY: all
all: day01

aoc.o: ../aoc.f90
	$(FC) $(FCFLAGS) $^ -c

day01 : main.f90 aoc.o
	$(FC) $(FCFLAGS) -o $@ $^



.PHONY: clean
clean:
	rm -f *.o day01 *.mod
