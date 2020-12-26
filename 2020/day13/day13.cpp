#include "../utils.hpp"

using namespace std;

i64 invmod(i64 x, i64 m) {
  auto b0 = m;
  i64 x0 = 0, x1 = 1;

  if (m == 1) {
    return 1;
  }

  while (x > 1) {
    i64 q = x / m;
    i64 amb = x % m;
    x = m;
    m = amb;

    i64 xqx = x1 - q * x0;
    x1 = x0;
    x0 = xqx;
  }

  if (x1 < 0) {
    x1 += b0;
  }

  return x1;
}

i64 crt(const vector<i64> &ni, const vector<i64> &ci) {
  auto N = utils::prod(ni);
  auto Ni = utils::map([&N](const auto &x) { return N / x; }, ni);
  auto di = utils::map([&](const auto &x) { return invmod(x.first, x.second); },
                       utils::zip(Ni, ni));

  i64 sum = 0;
  for (size_t i = 0; i < ni.size(); ++i) {
    sum += -ci[i] * di[i] * Ni[i];
  }
  return utils::mod(sum, N);
}

i64 part1(i64 timestamp, const vector<i64> &buses) {
  auto init_time = timestamp;
  while (true) {
    auto index = utils::findfirst(
        (i64)0, utils::map([&](const i64 &i) { return timestamp % i; }, buses));

    if (!index.has_value) {
      timestamp += 1;
    } else {
      return buses[index.unwrap] * (timestamp - init_time);
    }
  }
}

int main(int argc, char *argv[]) {
  if (argc == 1) {
    cerr << "No input file given\n";
    exit(1);
  }

  auto lines = utils::read_lines_as_string_view(argv[1]);
  auto timestamp = utils::to_int(lines[0]);
  auto buses = utils::filter([](const auto &x) -> bool { return x != "x"; },
                             utils::split_by(lines[1], ','));

  auto ids = utils::map(utils::to_int, buses);

  auto positions =
      utils::findall([](const auto &x) -> bool { return x != "x"; },
                     utils::split_by(lines[1], ','));

  cout << "Part1: " << part1(timestamp, ids) << '\n';
  cout << "Part2: " << crt(ids, positions) << '\n';

  return 0;
}
