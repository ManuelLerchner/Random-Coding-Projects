import random


def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    g, y, x = egcd(b % a, a)
    return (g, x - (b//a) * y, y)


def modinv(a, m):
    g, x, y = egcd(a, m)
    return x % m


def generateLargePrime(keySize):
    while True:
        num = random.randrange(2**(keySize-1), 2**keySize-1)
        if isPrime(num):
            return num


def isCoprime(p, q):
    return gcd(p, q) == 1


def isPrime(n):

    if n < 2:
        return False

    lowPrimes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443,
                 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997]

    if n in lowPrimes:
        return True

    for prime in lowPrimes:
        if n % prime == 0:
            return False

    # miller Rabin

    c = n-1

    while c % 2 == 0:
        c //= 2

    for i in range(128):
        if not rabinMiller(n, c):
            return False

    return True


def rabinMiller(n, c):

    a = random.randrange(2, n-2)
    x = pow(a, c, n)

    if x == 1 or x == n-1:
        return True

    while c != n-1:
        x = pow(x, 2, n)
        c *= 2

        if x == 1:
            return False
        elif x == n-1:
            return True

    return False


def gcd(p, q):
    while q:
        p, q = q, p % q
    return p


def generateKeys(keySize=16):
    e = d = n = 0

    p = generateLargePrime(keySize)
    q = generateLargePrime(keySize)

    n = p*q
    phiN = (p-1)*(q-1)

    while True:
        e = random.randrange(2**(keySize-1), 2**keySize-1)

        if isCoprime(e, phiN):
            break

    d = modinv(e, phiN)

    return e, d, n, (p, q)


def encrypt(e, n, msg):
    cipher = ""
    for c in msg:
        val = pow(ord(c), e, n)
        cipher += str(val) + " "
    return cipher


def decrypt(d, n, cipher):
    msg = ""

    for num in cipher.split():
        val = pow(int(num), d, n)
        msg += chr(val)
    return msg


############################################
############################################
############################################
message = "Hello, Word Lerchner Ind. is Back!"

e, d, n, Primes = generateKeys(keySize=128)

print(f"e= {e}")
print(f"d= {d}")
print(f"n= {n}")
print(f"p= {Primes[0]}")
print(f"q= {Primes[1]}")


encrypted = encrypt(e, n, message)
decrypted = decrypt(d, n, encrypted)


print(f"\nEncrypted: {encrypted}")
print(f"\nDecrypted: {decrypted}")
