#include "../helpers.hpp"
#include <algorithm>
#include <iostream>

using namespace std;

struct Data {
  char c;
  int low, high;
  string_view pass;
};

int part2(const vector<Data> &db) {

  int valid_passwords = 0;
  for (size_t i = 0; i < db.size(); ++i) {
    if (db[i].pass[db[i].low + 1] == db[i].c &&
        db[i].pass[db[i].high + 1] == db[i].c)
      continue;

    if (db[i].pass[db[i].low + 1] == db[i].c ||
        db[i].pass[db[i].high + 1] == db[i].c) {
      ++valid_passwords;
    }
  }

  return valid_passwords;
}

int part1(const vector<Data> &db) {
  int valid_passwords = 0;
  int occurs = 0;
  for (size_t i = 0; i < db.size(); ++i) {
    occurs = count(db[i].pass.begin(), db[i].pass.end(), db[i].c);
    if (occurs >= db[i].low && occurs <= db[i].high)
      ++valid_passwords;
  }

  return valid_passwords;
}

Data process_line(string_view line) {
  auto pos = line.find('-');
  int low = stoi(string(line.substr(0, pos)));
  line.remove_prefix(pos + 1);
  pos = line.find(' ');
  int high = stoi(string(line.substr(0, pos)));
  line.remove_prefix(pos + 1);
  char c = line[0];
  line.remove_prefix(1);
  pos = line.find(':');
  line.remove_prefix(pos);

  return {c, low, high, line};
}

int main(int argc, char *argv[]) {
  if (argc == 1) {
    cerr << "No input file given\n";
    exit(1);
  }
  auto lines = helpers::read_lines_as_string_view(argv[1]);

  vector<Data> db;
  db.reserve(lines.size());
  for (auto &x : lines) {
    db.push_back(process_line(x));
  }

  cout << "Part1: " << part1(db) << '\n';
  cout << "Part2: " << part2(db) << '\n';

  return 0;
}
