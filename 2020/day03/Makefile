FC       := gfortran
CXXFLAGS ?= -std=c++17 -Wall -pedantic -ggdb -O0
TARGETS   = day03f90 day03cpp

.PHONY: all
all: $(TARGETS)

day03f90 : day03.f90
	$(FC) -Wintrinsics-std -Wall -ggdb -o $@ $<

day03cpp : day03.cpp
	$(CXX) $^ $(CXXFLAGS) -o $@


.PHONY: clean
clean:
	rm -f *.o $(TARGETS)
