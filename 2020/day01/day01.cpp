#include "../../utils.hpp"
#include <algorithm>

using namespace std;

int part1(vector<i64> &lines) {

  const size_t N = lines.size();
  for (size_t i = 0; i < N; ++i) {
    auto l2 = find(lines.begin(), lines.end(), 2020 - lines[i]);
    if (l2 != end(lines)) {
      return lines[i] * (*l2);
    }
  }
  return -1;
}

int part2(vector<i64> &lines) {

  const size_t N = lines.size();
  for (size_t i = 0; i < N - 1; ++i) {
    for (size_t j = i; j < N; ++j) {
      auto l3 = find(lines.begin(), lines.end(), 2020 - lines[i] - lines[j]);
      if (l3 != end(lines)) {
        return lines[i] * lines[j] * (*l3);
      }
    }
  }
  return -1;
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
