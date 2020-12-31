#include "../../utils.hpp"
#include <cmath>

using namespace utils;
using namespace std;

i64 fuel_calc(const i64 &mass) { return floor(mass / 3) - 2; }

i64 part1(const vector<i64> &xs) {
  auto total_fuel = sum(map(fuel_calc, xs));
  return total_fuel;
}

i64 part2(const vector<i64> &xs) {
  auto fuel_calc_rec = [&](const i64 &mass) {
    i64 tempfuel = fuel_calc(mass);
    auto temp = tempfuel;
    while (fuel_calc(tempfuel) >= 0) {
      tempfuel = fuel_calc(tempfuel);
      temp += tempfuel;
    }
    return temp;
  };
  i64 total_fuel = sum(map(fuel_calc_rec, xs));
  return total_fuel;
}

int main(int argc, char *argv[]) {
  if (argc == 1) {
    cerr << "No input file given\n";
    exit(1);
  }

  auto lines =
      utils::map(utils::to_int, utils::read_lines_as_string_view(argv[1]));
  cout << part1(lines) << '\n';
  cout << part2(lines) << '\n';

  return 0;
}
