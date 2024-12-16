#include "../../utils.hpp"
#include <iostream>
#include <cctype>
#include <numeric>
#include <cstdio>

auto is_numeric(std::string_view sv) -> bool
{
  for (char c : sv)
  {
    if (!std::isdigit(c))
    {
      return false;
    }
  }
  return true;
}

auto parse_enabled(std::string_view expr)
{
  Vec<utils::V3<i64>> pairs;
  i64 lhs, rhs;

  i64 enabled = 1;
  for (std::size_t i = 0; i < expr.size(); ++i)
  {
    const auto es = expr.substr(i);
    if (expr.substr(i, 4) == "do()")
    {
      enabled = 1;
      i += 4;
    }
    if (expr.substr(i, 7) == "don\'t()")
    {
      enabled = 0;
      i += 7;
    }

    if (expr.substr(i, 4) == "mul(")
    {
      auto s = expr.substr(i + 4);
      i += 4;
      auto is = s.find(',');
      if (is_numeric(s.substr(0, is)))
      {
        lhs = utils::to_i64(s.substr(0, is));
      }
      else
      {
        continue;
      }
      s = s.substr(is + 1);
      i += is + 1;
      is = s.find(')');

      if (is_numeric(s.substr(0, is)))
      {
        rhs = utils::to_i64(s.substr(0, is));
      }
      else
      {
        continue;
      }

      i += is;

      pairs.emplace_back(lhs, rhs, enabled);
    }
  }

  return pairs;
}

auto parse_muls(std::string_view expr) -> Vec<utils::V2>
{
  Vec<utils::V2> pairs;

  std::size_t i;
  std::size_t cursor = 0;
  i32 lhs, rhs;
  while (cursor < expr.size())
  {
    auto news = expr.substr(cursor);
    i = news.find("mul(");
    if (i == news.npos)
      break;
    news = news.substr(i + 4);
    cursor += i + 4;
    // find comma
    i = news.find(',');
    if (is_numeric(news.substr(0, i)))
    {
      lhs = utils::to_i32(news.substr(0, i));
    }
    else
    {
      continue;
    }
    news = news.substr(i + 1);
    cursor += i + 1;
    i = news.find(')');

    if (is_numeric(news.substr(0, i)))
    {
      rhs = utils::to_i32(news.substr(0, i));
    }
    else
    {
      continue;
    }

    pairs.emplace_back(rhs, lhs);

    news = news.substr(i);
    cursor += i;
  }

  return pairs;
}
auto main(i32 argc, c8 *argv[]) -> i32
{
  const auto file = utils::read_file_as_string_view(argv[1]);

  const auto pairs = parse_muls(file);

  const auto p1 = std::transform_reduce(pairs.cbegin(), pairs.cend(), 0, std::plus{},
                                        [](auto p)
                                        { return p.x * p.y; });

  std::cout << "Part1: " << p1 << '\n';

  const auto pairs2 = parse_enabled(file);

  const auto p2 = std::transform_reduce(pairs2.cbegin(), pairs2.cend(), 0, std::plus{},
                                        [](auto p)
                                        { return p.x * p.y * p.z; });

  std::cout << "Part2: " << p2 << '\n';

  return 0;
}
