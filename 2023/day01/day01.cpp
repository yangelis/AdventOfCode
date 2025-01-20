#include "../../utils.hpp"
#include <cmath>
#include <iostream>

using pair = utils::tV2<i32>;

auto part2(const Vec<std::string_view> &lines) -> i32
{

  const Vec<std::string> maps = {"one", "two", "three", "four", "five",
                                 "six", "seven", "eight", "nine"};
  i32 res = 0;
  for (auto &&line : lines)
  {
    Vec<pair> idn;

    for (std::size_t i = 0; i < 9; ++i)
    {
      auto it = line.find(maps[i]);
      while (it != std::string::npos)
      {
        idn.emplace_back(it, i + 1);
        it = line.find(maps[i], it + maps[i].size());
      }
    }

    for (std::size_t i = 0; i < line.size(); ++i)
    {
      if (std::isdigit(line[i]))
      {
        idn.emplace_back(i, static_cast<i32>(line[i] - '0'));
      }
    }

    std::sort(std::begin(idn), std::end(idn),
              [](pair p1, pair p2)
              {
                return p1.x < p2.x;
              });

    const std::size_t n = idn.size();
    if (n == 1)
    {
      res += idn[0].y * 11;
    }
    else if (n > 1)
    {
      res += idn[0].y * 10 + idn[n - 1].y;
    }
  }

  return res;
}

auto part1(const Vec<std::string_view> &lines) -> i32
{

  i32 res = 0;
  for (auto &&line : lines)
  {
    const auto nums = utils::map(
        [](c8 n)
        { return static_cast<i32>(n - '0'); },
        utils::filter([](auto ch) -> bool
               { return std::isdigit(ch); }, line));

    const std::size_t n = nums.size();
    if (n == 1)
    {
      res += nums[0] * 11;
    }
    else if (n > 1)
    {
      res += nums[0] * 10 + nums[n - 1];
    }
  }

  return res;
}

auto main(i32 argc, c8 *argv[]) -> i32
{

  const auto lines = utils::read_lines_as_string_view(argv[1]);

  const auto p1 = part1(lines);
  std::cout << "Part1: " << p1 << '\n';

  const auto p2 = part2(lines);
  std::cout << "Part2: " << p2 << '\n';

  return 0;
}
