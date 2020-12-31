#include "../../utils.hpp"

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

size_t solve_convolution(const Matrix<u8> &grid, const Matrix<u8> &kernel) {
  auto in_r = grid.rows;
  auto in_c = grid.cols;
  auto kn_r = kernel.rows;
  auto kn_c = kernel.cols;

  auto istep = kn_r;
  auto jstep = kn_c;

  auto n = in_r * kn_c / in_r + 1;
  vector<Matrix<u8>> temp(n, grid);
  auto paded_grid = hcat(temp);

  size_t s = 0;

  // for (size_t i = 0; i < in_r - kn_r; i += istep) {
  //   s +=
  // }

  return 69;
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

  // i32 k1[][4] = {{0, 0, 0, 0}, {0, 0, 0, 1}};
  // Matrix<i32> kernel1(k1);
  // kernel1.print();
  // auto temp = hcat(kernel1, kernel1);
  // temp.print();

  // vector<Matrix<i32>> m(2, kernel1);
  // auto temp2 = hcat(m);
  // temp2.print();
  return 0;
}
