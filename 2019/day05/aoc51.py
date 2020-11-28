import numpy as np


def program_alarm(numbers, v, n):
    numbers[1] = n
    numbers[2] = v
    return numbers

def reseter(numbers):

    # for noun in range(0, 100, 1):
    #     for verb in range(100, 0, -1):
    #         numbers = program_alarm(nums.copy(), verb, noun)
    for i in range(0, numbers.size, 4):
        opcode = numbers[i]
        digits = [int(x) for x in str(opcode)]
        while len(digits) < 4:
            digits = [0]+digits
        if opcode == 99:
            break

        pos1 = numbers[i + 1]
        pos2 = numbers[i + 2]
        pos3 = numbers[i + 3]

        if opcode == 1:
            arg1 = numbers[pos1]
            arg2 = numbers[pos2]
            numbers[pos3] = (pos1 if digits[0] == 1 else arg1) + ( pos2 if digits[1] == 1 else arg2)
        elif opcode == 2:
            numbers[pos3] = (pos1 if digits[0] == 1 else arg1) * ( pos2 if digits[1] == 1 else arg2)
            arg1 = numbers[pos1]
            arg2 = numbers[pos2]
        elif opcode == 3:
            pos1 = numbers[i+1]
            numbers[pos1] = 1 # special input
        elif opcode == 4:
            pos1 = numbers[i+1]
            print
        return numbers[0]
                # if numbers[0] == 19690720:
                #     return 100 * noun + verb





numbers = np.genfromtxt("input.txt", delimiter=',', dtype=int)
val = reseter(numbers)
print(val)
