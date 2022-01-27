from itertools import product


nums = [1, 2, 3, 4, 5]

places = 6


combination = list(product(nums, repeat=6))

sum = 0
for comb in combination:

    if comb.count(1) <= 2 and comb.count(2) <= 2 and comb.count(3) <= 2 and comb.count(4) <= 2 and comb.count(5) <= 2:
        sum += 1


print(sum)
