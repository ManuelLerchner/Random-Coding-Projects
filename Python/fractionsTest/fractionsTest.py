num = 2.5432


def findFraction01(num, error=0.000000000000001):
    LF = (0, 1)
    HF = (1, 1)
    iter = 0

    if num == 1:
        return HF
    if num == 0:
        return LF

    while True:
        MF = (LF[0]+HF[0], LF[1]+HF[1])

        M = MF[0]/MF[1]
        L = LF[0]/LF[1]
        H = HF[0]/HF[1]

        iter += 1
        if(M < num-error):
            LF = MF
            continue
        if(M > num+error):
            HF = MF
            continue

        print("tollerance:", abs(num-M))
        print("iterations:", iter)
        return MF


def findFraction(num):
    integer = int(num)
    fractional = num-integer

    frac = findFraction01(fractional)

    total = (frac[0]+integer*frac[1], frac[1])
    return total


frac = findFraction(num)

print(frac)
