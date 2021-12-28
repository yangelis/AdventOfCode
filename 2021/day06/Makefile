FC       := gfortran
FCFLAGS  := -std=f2008 -ffree-form -Wall -Wextra -Wpedantic -fimplicit-none \
            -fcheck=all -I.. -O0 -ggdb -Wline-truncation \
            -Wcharacter-truncation -Wsurprising -Waliasing -fno-omit-frame-pointer \
            -Wimplicit-interface -Wunused-parameter -fwhole-file -fbacktrace -Wrealloc-lhs

TARGET = day06

.PHONY: all
all: $(TARGET)

aoc.o: ../aoc.f90
	$(FC) $(FCFLAGS) $^ -c

$(TARGET) : main.f90 aoc.o
	$(FC) $(FCFLAGS) -o $@ $^

.PHONY: clean
clean:
	rm -f *.o $(TARGET) *.mod
