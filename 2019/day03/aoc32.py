import numpy as np

dx = {"L": -1, "R": 1, "U": 0, "D": 0}
dy = {"L": 0, "R": 0, "U": 1, "D": -1}



def get_points(inst):
    x = 0
    y = 0
    ans = {}
    length = 0
    for cmd in inst:
        cmd = cmd.decode()
        d = cmd[0]
        n = int(cmd[1:])
        assert d in ['L', 'R', 'U', 'D']
        for _ in range(n):
            x += dx[d]
            y += dy[d]
            length += 1
            if (x,y) not in ans:
                ans[(x,y)] = length

    return ans



instructions = np.genfromtxt("input.txt", delimiter=',', dtype='S5')
P1 = get_points(instructions[0])
P2 = get_points(instructions[1])
both = set(P1.keys()) & set(P2.keys())
ans = min([P1[l] + P2[l] for l in both])
print(ans)
