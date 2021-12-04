FC       := gfortran
FCFLAGS  := -std=f2008 -ffree-form -Wall -Wextra -Wpedantic -I.. -O0 -ggdb
TARGET = day03

.PHONY: all
all: $(TARGET)

aoc.o: ../aoc.f90
	$(FC) $(FCFLAGS) $^ -c

$(TARGET) : main.f90 aoc.o
	$(FC) $(FCFLAGS) -o $@ $^

.PHONY: clean
clean:
	rm -f *.o $(TARGET) *.mod
