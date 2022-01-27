from itertools import permutations
import math

nums = [1, 2, 3, 4,5,6,7]

places = 6


combination = list(permutations(nums, r=len(nums)))

sum = 0
for comb in combination:

    for i in range(len(nums)):
        if(nums[i] == comb[i]):
            sum += 1


print(sum/math.factorial(len(nums)))
