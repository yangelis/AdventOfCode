#include "../../utils.hpp"
#include <map>

using utils::V2;

struct Wire {
  V2 start;
  V2 stop;
  std::vector<V2> points;
};

std::map<char, int> DX = {{'U', 0}, {'D', 0}, {'R', 1}, {'L', -1}};
std::map<char, int> DY = {{'U', 1}, {'D', -1}, {'R', 0}, {'L', 0}};

void update_position(Wire &wire,
                     const std::vector<std::pair<char, int>> &moves) {
  wire.start = {0, 0};
  V2 pos = {0, 0};

  for (const auto &[m, n] : moves) {
    for (size_t i = 0; i < n; ++i) {
      pos = {pos.x + DX[m], pos.y + DY[m]};
      wire.points.emplace_back(pos);
    }
  }

  wire.stop = pos;
}

std::vector<V2> find_intersections(const std::vector<Wire> &wires) {
  std::vector<V2> ret;

  auto p0 = wires[0].points;
  auto p1 = wires[1].points;
  std::sort(p0.begin(), p0.end());
  std::sort(p1.begin(), p1.end());
  std::set_intersection(p0.begin(), p0.end(), p1.begin(), p1.end(),
                        std::back_inserter(ret));

  return ret;
}

auto closest_distance(const std::vector<Wire> &wires) -> size_t {
  auto intersections = find_intersections(wires);

  std::vector<double> distances;
  for (size_t i = 0; i < intersections.size(); ++i) {
    distances.push_back(manhattan_dist(intersections[i], {0, 0}));
  }
  auto min_value = std::min_element(distances.begin(), distances.end());

  return *min_value;
}

auto calc_steps(const std::vector<Wire> &wires) -> size_t {

  auto intersections = find_intersections(wires);

  // start from one
  std::vector<size_t> steps(intersections.size(), 1);

  for (size_t i = 0; i < steps.size(); ++i) {

    for (const auto &wire : wires) {
      steps[i] +=
          utils::findfirst([&](const V2 p) { return p == intersections[i]; },
                           wire.points)
              .unwrap;
    }
  }

  return *std::min_element(steps.begin(), steps.end());
}

int main(int argc, char *argv[]) {

  if (argc == 1) {
    fprintf(stderr, "No input file given\n");
    exit(1);
  }

  auto lines = utils::read_lines_as_string_view(argv[1]);
  auto parse_move = [](const std::string_view &p) {
    return std::make_pair(p[0], std::atoi(&p[1]));
  };
  auto parse_dir = [&parse_move](const auto &line) {
    auto parts = utils::split_by(line, ',');
    auto vec = utils::map(parse_move, parts);

    return vec;
  };

  auto directions = utils::map(parse_dir, lines);

  std::vector<Wire> wires(lines.size());

  for (size_t i = 0; i < lines.size(); ++i) {
    update_position(wires[i], directions[i]);
  }

  std::cout << "Part1: " << closest_distance(wires) << '\n';
  std::cout << "Part2: " << calc_steps(wires) << '\n';
  return 0;
}
