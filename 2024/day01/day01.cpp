#include "../../utils.hpp"
#include <iostream>
#include <numeric>

auto part1(std::vector<i32> &lc, std::vector<i32> &rc) -> i32
{
    std::sort(std::begin(lc), std::end(lc));
    std::sort(std::begin(rc), std::end(rc));

    // i32 total = 0;

    // const auto n = lc.size();
    // for (std::size_t i = 0; i < n; ++i)
    // {
    //     total += std::abs(lc[i] - rc[i]);
    // }

    const auto total = std::transform_reduce(lc.cbegin(), lc.cend(), rc.cbegin(), 0, std::plus{}, [](const auto l, const auto r)
                                             { return std::abs(l - r); });
    return total;
}

auto part2(const std::vector<i32> &lc, const std::vector<i32> &rc) -> i32
{
    i32 total = 0;

    const auto n = lc.size();
    for (std::size_t i = 0; i < n; ++i)
    {
        const auto diffs = utils::sum(utils::map([&](const auto &r)
                                                 { return 1 - static_cast<i32>(static_cast<bool>(std::abs(lc[i] - r))); }, rc));

        total += lc[i] * diffs;
    }

    return total;
}

auto main(i32 argc, c8 *argv[]) -> i32
{
    auto file = utils::read_file_as_string_view(argv[1]);

    const auto lines = utils::map(
        [](const auto &x)
        { return utils::split_by(x, "   "); },
        utils::split_lines(file)

    );

    std::vector<i32> left_col, right_col;
    left_col.reserve(lines.size());
    right_col.reserve(lines.size());
    for (const auto &line : lines)
    {
        left_col.push_back(utils::to_i32(line[0]));
        right_col.push_back(utils::to_i32(line[1]));
    }

    const auto p1 = part1(left_col, right_col);
    std::cout << "Part1: " << p1 << '\n';
    const auto p2 = part2(left_col, right_col);
    std::cout << "Part2: " << p2 << '\n';

    return 0;
}