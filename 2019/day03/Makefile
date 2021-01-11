CXXFLAGS ?= -std=c++17 -Wall -pedantic -ggdb -O0
TARGETS = day03

.PHONY: all
all: $(TARGETS)

$(TARGETS): % : %.cpp
	$(CXX) $^ $(CXXFLAGS) -o $@

.PHONY: clean
clean:
	rm -f *.o $(TARGETS)
