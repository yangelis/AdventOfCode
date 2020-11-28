import numpy as np

def no_decr(dig):
    return any([dig[i] > dig[i+1] for i in range(len(dig)-1)])
def no_duo(dig):
    return any([dig[i] == dig[i+1] for i in range(len(dig)-1)])


def pswd(rg):
    ans = 0
    for i in range(rg[0], rg[1]+1):
        digits = [int(x) for x in str(i)]
        has_pair = no_duo(digits)
        has_dec = no_decr(digits)
        if has_pair and not has_dec:
            ans += 1
    return ans
rng = np.loadtxt("input.txt", delimiter='-', dtype=int)

print(pswd(rng))
