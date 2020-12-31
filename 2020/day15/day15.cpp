#include "../../utils.hpp"
#include <algorithm>
#include <unordered_map>

using namespace std;

auto solve3(vector<i64> &line, int iterations) {
  vector<int> spoken_time;
  spoken_time.reserve(iterations);
  const auto N = line.size();
  for (int i = 0; i < N - 1; ++i) {
    spoken_time.push_back(line[i]);
  }

  int next = line.back();
  for (int i = N - 1; i < iterations - 1; ++i) {
    auto ptr = find(spoken_time.begin(), spoken_time.end(), next);
    int tmp =
        ptr != spoken_time.end() ? i - distance(spoken_time.begin(), ptr) : 0;
    spoken_time[i] = next;
    next = tmp;
  }
  return next;
}
auto solve2(vector<i64> &line, int iterations) {
  const auto N = line.size();
  unordered_map<int, int> spoken_time;
  for (int i = 0; i < N - 1; ++i) {
    spoken_time[line[i]] = i;
  }

  int next = line.back();
  for (int i = N - 1; i < iterations - 1; ++i) {
    auto ptr = spoken_time.find(next);
    int tmp = ptr != spoken_time.end() ? i - ptr->second : 0;
    spoken_time.insert_or_assign(next, i);
    next = tmp;
  }
  return next;
}

int main(int arc, char *argv[]) {
  auto lines = utils::map(utils::to_int, utils::split_by(utils::read_file_as_string_view(argv[1]), ','));

  // cout << solve(lines, 2020) << '\n';
  cout << solve2(lines, 2020) << '\n';
  // cout << solve3(lines, 2020) << '\n';
  cout << solve2(lines, 30000000) << '\n';
  return 0;
}
