import numpy as np


def fft(D):
    n = len(D)

    if n == 1:
        return D

    w = np.exp(-2j*np.pi/n)

    Pe, Po = D[::2], D[1::2]
    ye, yo = fft(Pe), fft(Po)

    c = [0]*n

    for k in range(n//2):
        c[k] = ye[k]+yo[k]*w**k
        c[k+n//2] = ye[k]-yo[k]*w**k

    return np.round(c, decimals=5)


def ifft_Alg(D):

    n = len(D)

    if n == 1:
        return D

    w = np.exp(2j*np.pi/n)

    Pe, Po = D[::2], D[1::2]
    ye, yo = ifft_Alg(Pe), ifft_Alg(Po)

    c = [0]*n

    for k in range(n//2):
        c[k] = ye[k]+yo[k]*w**k
        c[k+n//2] = ye[k]-yo[k]*w**k

    return np.round(c, decimals=5)


def ifft(D):
    length = len(D)
    isPowerOf2 = length & (length - 1) == 0

    assert isPowerOf2, "Len should be a Power of 2'"
    return ifft_Alg(D)/len(D)


def PolMult(P1, P2):
    out = [0]*(len(P1)+len(P2)-1)
    for i in range(len(P1)):
        for j in range(len(P2)):
            x = P1[i]
            y = P2[j]

            out[i+j] += x*y
    return out


def fourierPolMul(P1, P2):
    P1_ext = np.concatenate([P1, np.zeros(len(P1))])
    P2_ext = np.concatenate([P2, np.zeros(len(P2))])

    fftP1 = fft(P1_ext)
    fftP2 = fft(P2_ext)

    prod = np.multiply(fftP1, fftP2)
    out = np.round(ifft(prod), decimals=3).real

    return out.tolist()


P1 = np.array([1, 2, 3, 4, 4, 3, 2, 1])
P2 = np.array([10, 9, 10, -5, 10, 0.5, -0.3, 23])


print("pol mult", PolMult(P1, P2))


print("fft mult", fourierPolMul(P1, P2))
