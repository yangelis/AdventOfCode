CXXFLAGS ?= -std=c++17 -Wall -pedantic -ggdb -O0
TARGETS   = day04cpp

.PHONY: all
all: $(TARGETS)

day04cpp : day04.cpp
	$(CXX) $^ $(CXXFLAGS) -o $@


.PHONY: clean
clean:
	rm -f *.o $(TARGETS)
