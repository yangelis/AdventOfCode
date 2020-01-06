import numpy as np


def program_alarm(numbers, v, n):
    numbers[1] = n
    numbers[2] = v
    return numbers

def reseter(nums):

    for noun in range(0, 100, 1):
        for verb in range(100, 0, -1):
            numbers = program_alarm(nums.copy(), verb, noun)
            for i in range(0, numbers.size, 4):
                if numbers[i] == 99:
                    break
                
                pos1 = numbers[i + 1]
                pos2 = numbers[i + 2]
                pos3 = numbers[i + 3]

                arg1 = numbers[pos1]
                arg2 = numbers[pos2]
                if numbers[i] == 1:
                    numbers[pos3] = arg1 + arg2
                elif numbers[i] == 2:
                    numbers[pos3] = arg1 * arg2

                if numbers[0] == 19690720:
                    return 100 * noun + verb





numbers = np.genfromtxt("input.txt", delimiter=',', dtype=int)
val = reseter(numbers)
print(val)
