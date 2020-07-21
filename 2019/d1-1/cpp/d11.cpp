#include <iostream>
#include <fstream>
#include <string>
// #include <string_view>
#include <math.h>

size_t fuel_calc(const size_t mass)
{
    auto fuel = std::floor(mass / 3) - 2;
    return fuel;
};

int main()
{
    std::ifstream inputf("../input.txt");
    size_t total_fuel = 0;
    if (inputf.is_open())
    {
        std::string line;
        while (std::getline(inputf, line))
        {
            total_fuel += fuel_calc(std::stoi(line));
        }
    }
    inputf.close();
    std::cout << total_fuel << '\n';

    return 0;
}
