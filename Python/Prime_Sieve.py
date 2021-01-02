from math import sqrt, ceil
import timing


N = pow(10, 3)
Ergebnisse = [2, 3, 5]
Sieb = [False for i in range(N)]


def loesung(a, n, xgreatery=False):
	sol = 0
	root = sqrt(n)
	if xgreatery:
		for x in range(1, ceil(root / 1.41421)):
			y = sqrt(abs((a * x * x - n)))
			if float(y).is_integer():
				sol += 1
	else:
		for x in range(1, ceil(root / 1.7320)):
			y = sqrt(abs((n - a * x * x)))
			if float(y).is_integer():
				sol += 1
	if sol & 1 == 1:
		Sieb[n] = not Sieb[n]


for n in range(0, len(Sieb)):
	val = n % 60
	if val == 1 or val == 13 or val == 17 or val == 29 or val == 37 or val == 41 or val == 49 or val == 53:
		loesung(4, n)
	elif val == 7 or val == 19 or val == 31 or val == 43:
		loesung(3, n)
	elif val == 11 or val == 23 or val == 47 or val == 59:
		loesung(3, n, True)

for n in range(0, len(Sieb)):
	if Sieb[n]:
		Ergebnisse.append(n)
		k = n * n
		while k < len(Sieb):
			Sieb[k] = False
			k += n * n

print(Ergebnisse)
print(len(Ergebnisse))
