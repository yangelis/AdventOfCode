#include "../../utils.hpp"
#include <iostream>

template <typename T>
static inline auto pop_new_vec(const Vec<T> &vec, i32 bad_id)
    -> Vec<T>
{
    const i32 n = vec.size();
    Vec<T> ret;
    ret.reserve(n);

    for (i32 i = 0; i < n; ++i)
    {
        if (i == bad_id)
            continue;
        ;
        ret.emplace_back(vec[i]);
    }
    return ret;
}

auto issafe(const Vec<i32> &report) -> bool
{
    for (const auto &pp : utils::zip(report, report, 0, 1))
    {
        if (!(1 <= (pp.second - pp.first) && (pp.second - pp.first) <= 3))
        {
            return false;
        }
    }
    return true;
}

auto istolerable(const Vec<i32> &report) -> bool
{
    const auto n = report.size() - 1;

    i32 ibad = -1;
    bool violation_one = false;

    for (std::size_t i = 0; i < n; ++i)
    {
        const auto diff = report[i + 1] - report[i];
        if (!((1 <= diff) && (diff <= 3)))
        {
            ibad = i;
            break;
        }
    }

    if (ibad == -1)
        return true;

    auto new_report = pop_new_vec(report, ibad);

    for (const auto &pp : utils::zip(new_report, new_report, 0, 1))
    {
        const auto diff = pp.second - pp.first;
        if (!((1 <= diff) && (diff <= 3)))
        {
            violation_one = true;
            break;
        }
    }

    if (!violation_one)
        return true;
    new_report = pop_new_vec(report, ibad + 1);

    for (const auto &pp : utils::zip(new_report, new_report, 0, 1))
    {
        const auto diff = pp.second - pp.first;
        if (!((1 <= diff) && (diff <= 3)))
        {
            return false;
        }
    }
    return true;
}

auto part1(const Vec<Vec<i32>> &reports) -> i32
{
    i32 safe_count = 0;
    for (const auto &report : reports)
    {
        Vec<i32> rev_report(report.size());
        std::reverse_copy(report.begin(), report.end(), rev_report.begin());
        if (issafe(report) || issafe(rev_report))
        {
            safe_count++;
        }
    }
    return safe_count;
}

auto part2(const Vec<Vec<i32>> &reports) -> i32
{
    i32 safe_count = 0;
    for (const auto &report : reports)
    {
        Vec<i32> rev_report(report.size());
        std::reverse_copy(report.begin(), report.end(), rev_report.begin());
        if (istolerable(report) || istolerable(rev_report))
        {
            safe_count++;
        }
    }
    return safe_count;
}

auto main(i32 argc, c8 *argv[]) -> i32
{
    auto file = utils::read_file_as_string_view(argv[1]);

    const auto lines = utils::map(
        [](const auto &x)
        { return utils::split_by(x, " "); },
        utils::split_lines(file)

    );

    const auto reports = utils::map([](const auto &y)
                                    { return utils::map(
                                          [&](const auto &x)
                                          { return utils::to_i32(x); },
                                          y

                                      ); }, lines);

    const auto p1 = part1(reports);
    std::cout << "Part1: " << p1 << '\n';
    const auto p2 = part2(reports);
    std::cout << "Part2: " << p2 << '\n';

    return 0;
}
