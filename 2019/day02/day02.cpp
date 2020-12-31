#include "../../utils.hpp"

using namespace utils;
using namespace std;

struct Machine {
  vector<i64> memory;

  static int run(const Machine &machine, int a, int b) {
    auto mem = machine.memory;
    mem[1] = a;
    mem[2] = b;

    size_t i = 0;
    while (mem[i] != 99) {
      size_t istep = 0;
      switch (mem[i]) {
      case 1: {
        istep = 4;
        mem[mem[i + 3]] = mem[mem[i + 1]] + mem[mem[i + 2]];
      } break;
      case 2: {
        istep = 4;
        mem[mem[i + 3]] = mem[mem[i + 1]] * mem[mem[i + 2]];
      } break;
      }
      i += istep;
    }

    return mem[0];
  }
};

int main(int argc, char *argv[]) {
  if (argc == 1) {
    cerr << "No input file given\n";
    exit(1);
  }

  auto lines = map(to_int, split_by(read_file_as_string_view(argv[1]), ','));
  Machine machine = {lines};
  cout << Machine::run(machine, 12, 2) << '\n';
  for (const auto &[noun, verb] : cartesian(arange(0, 99), arange(0, 99))) {
    if (Machine::run(machine, noun, verb) == 19690720) {
      cout << noun * 100 + verb << '\n';
      break;
    }
  }

  return 0;
}
