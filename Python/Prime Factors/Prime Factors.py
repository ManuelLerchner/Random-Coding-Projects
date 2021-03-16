from math import sqrt, ceil
import timing

num = 600851475143
prime = [2]


def primes(n):
    valid = True
    for i in range(2, ceil(sqrt(n)) + 1):
        if n % i == 0:
            valid = False
            break
    if valid:
        prime.append(n)


for k in range(2, 100):
    primes(k)

print(prime)

primeFactors = []
for k in prime:
    if num % k == 0:
        primeFactors.append(k)

print(primeFactors)
