#include "../utils.hpp"

using namespace std;
using namespace utils;

size_t solve(const Matrix<u8> &grid, pair<size_t, size_t> directions = {3, 1}) {
  size_t n_trees = 0;

  for (size_t i = 0, j = 0; i < grid.rows;
       i += directions.second, j += directions.first) {
    if (grid(i, j % grid.cols) == '#') {
      ++n_trees;
    }
  }

  return n_trees;
}

int main(int argc, char *argv[]) {
  if (argc == 1) {
    cerr << "No file given!\n";
    exit(1);
  }

  auto lines = read_lines_as_string_view(argv[1]);
  auto grid = Matrix<u8>::create_mat_from_lines(lines);

  cout << "Part1: " << solve(grid) << '\n';
  cout << "Part1: "
       << solve(grid, {1, 1}) * solve(grid, {3, 1}) * solve(grid, {5, 1}) *
              solve(grid, {7, 1}) * solve(grid, {1, 2})
       << '\n';

  return 0;
}
