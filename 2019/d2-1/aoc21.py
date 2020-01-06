import numpy as np

def program_alarm(numbers):
    print(numbers)
    numbers[1] = 12
    numbers[2] = 2
    print(numbers)

def computah(numbers):
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

        return numbers[0]

   
def printah(numbers):
    countah = 0
    for num in numbers:
        if num != 99:
            if countah == 4:
                print()
            countah += 1
            print(num, end=',')
        else:
            print()
            print(num)
numbers = np.genfromtxt("input.txt", delimiter=',', dtype=int)

print(numbers)

print(f'The output at 0 is: {program_alarm(numbers)}')
computah(numbers)
printah(numbers)
