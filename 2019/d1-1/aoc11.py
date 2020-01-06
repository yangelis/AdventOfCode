import numpy as np



def totalFuel(mass):
    return np.floor(mass / 3) - 2


input_file = np.genfromtxt("input.txt",dtype=float)

total_fuel = 0
for line in input_file:
    total_fuel += totalFuel(line)

print(total_fuel)
