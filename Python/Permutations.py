import timing

myInput = [str(a) for a in range(3)]
beginsWith = ""


def swap(a, pos1, pos2):
	a[pos1], a[pos2] = a[pos2], a[pos1]


def generate(k, a):
	if k == 1:
		text = ""
		for st in a:
			text += st
		permutations.append(text)
	else:
		generate(k - 1, a)
		for l in range(0, k - 1):
			if k & 1 == 0:
				swap(a, l, k - 1)
			else:
				swap(a, 0, k - 1)
			generate(k - 1, a)


def remove_duplicates(a):
	return list(set(a))


permutations = []
generate(len(myInput), myInput)

cleared = remove_duplicates(permutations)

count = 0
for S in cleared:
	valid = True
	for i in range(0, len(beginsWith)):
		if not (S[i] == beginsWith[i]):
			valid = False
			break
	if valid:
		count += 1

print("")
print("Calculated " + str(len(permutations)) + " Permutations")
print("Found " + str(len(cleared)) + " distinct permutations, " + str(count) + " of them starts with " + beginsWith)

print(permutations)