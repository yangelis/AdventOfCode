#include "../../utils.hpp"
#include <sstream>

using namespace std;
using namespace utils;

struct Passport {
  string_view byr, iyr, eyr;
  string_view hgt;
  string_view hcl, ecl;
  string_view pid, cid;

  bool is_present() const {
    return !byr.empty() && !iyr.empty() && !eyr.empty() && !hgt.empty() &&
           !hcl.empty() && !ecl.empty() && !pid.empty();
  }

  bool is_valid() const {
    if (!is_present()) {
      return false;
    }

    if (!inRange(byr, 1920, 2002) || !inRange(iyr, 2010, 2020) ||
        !inRange(eyr, 2020, 2030)) {
      return false;
    }

    bool checkHeight = false;
    if (hgt.find("cm") != -1) {
      checkHeight = inRange(hgt.substr(0, hgt.size() - 2), 150, 193);
    }

    if (hgt.find("in") != -1) {
      checkHeight = inRange(hgt.substr(0, hgt.size() - 2), 59, 76);
    }

    if (!checkHeight) {
      return false;
    }

    if (hcl[0] != '#' || hcl.size() != 7 ||
        hcl.substr(1).find_first_not_of("0123456789abcdef") != -1) {
      return false;
    }

    if (!match(ecl, "amb", "blu", "brn", "gry", "grn", "hzl", "oth")) {
      return false;
    }

    if (pid.size() != 9 || !try_int(pid).has_value) {
      return false;
    }

    return true;
  }
};

int main(int argc, char *argv[]) {

  if (argc == 1) {
    cerr << "No file given!\n";
    exit(1);
  }

  auto file = read_file_as_string_view(argv[1]);
  auto splitter = [](const auto &x) { return split_by(x, '\n'); };
  auto lines = map(splitter, split_by(file, "\n\n"));

  vector<Passport> passports;
  passports.reserve(lines.size());

  for (auto &l : lines) {
    Passport pass = {};
    auto line = join_string_view(l);
    auto parts = split_by(line, ' ');

    for (auto &p : parts) {
      if (p.find("byr:") == 0) {
        pass.byr = p.substr(4);
      } else if (p.find("iyr:") == 0) {
        pass.iyr = p.substr(4);
      } else if (p.find("eyr:") == 0) {
        pass.eyr = p.substr(4);
      } else if (p.find("hgt:") == 0) {
        pass.hgt = p.substr(4);
      } else if (p.find("hcl:") == 0) {
        pass.hcl = p.substr(4);
      } else if (p.find("ecl:") == 0) {
        pass.ecl = p.substr(4);
      } else if (p.find("pid:") == 0) {
        pass.pid = p.substr(4);
      } else if (p.find("cid:") == 0) {
        pass.cid = p.substr(4);
      }
    }
    passports.push_back(pass);
  }

  auto part1 =
      filter([](auto &p) -> bool { return p.is_present(); }, passports).size();

  auto part2 =
      filter([](auto &p) -> bool { return p.is_valid(); }, passports).size();

  cout << "Part1: " << part1 << '\n';
  cout << "Part2: " << part2 << '\n';

  return 0;
}
