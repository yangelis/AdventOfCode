#include <iostream>
#include <fstream>
#include <string>
#include <math.h>

size_t fuel_calc2(const size_t mass)
{
    auto fuel = std::floor(mass / 3) - 2;
    if (std::floor(fuel / 3) - 2 > 0)
        return fuel_calc2(fuel);
    else
    {
        return fuel;
    }
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
            total_fuel += fuel_calc2(std::stoi(line));
        }
    }
    inputf.close();
    std::cout << total_fuel << '\n';

    return 0;
}
