
def read_file(file_name: str):
    with open(file_name, "r") as file:
        return [int(i) for i in file.read().split()]


def countIncreases(l):
    count = 0
    prev = l[0]
    for i in l[1:]:
        if(i > prev):
            count += 1

        prev = i
    return count


def getSlidingWindows(data):
    combined = []
    for (i, num) in enumerate(data[:-2]):
        window1 = data[i:i+3]

        if len(window1) < 3:
            continue

        sum1 = sum(window1)

        combined.append(sum1)

    return combined


lines = read_file("1/data.txt")

print("part1", countIncreases(lines))


window = getSlidingWindows(lines)
print("part2", countIncreases(window))
