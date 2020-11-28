import numpy as np



def totalFuel(mass):
    return np.floor(mass / 3) - 2


masses = np.genfromtxt("../input.txt", dtype=int)
#masses = np.array([1969])
total_fuel = 0
#print(masses)

for i in range(0, masses.shape[0]):
    temp_fuel = 0
    temp_fuel += totalFuel(masses[i])
    total_fuel += temp_fuel
    #print(temp_fuel)
    while totalFuel(temp_fuel) >= 0:
        temp_fuel = totalFuel(temp_fuel)
    #    print(temp_fuel)
        total_fuel += temp_fuel

print(total_fuel)
