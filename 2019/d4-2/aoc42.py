import numpy as np

def decr(dig):
    return any([dig[i] > dig[i+1] for i in range(len(dig)-1)])
def duo(dig):
    return any([(i == 0 or dig[i] != dig[i-1]) and dig[i] == dig[i+1] and (i == len(dig)-2 or dig[i] != dig[i+2]) for i in range(len(dig) - 1)])

def pswd(rg):
    ans = 0
    for i in range(rg[0], rg[1]+1):
        digits = [int(x) for x in str(i)]
        has_pair = duo(digits)
        has_dec = decr(digits)
        if has_pair and not has_dec:
            ans += 1
    return ans
rng = [136760, 595730]
print(pswd(rng))
