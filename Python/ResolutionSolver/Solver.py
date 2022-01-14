
import pprint

conditions = [
    {"p", "-w"},
    {"p", "y"},
    {"-p", "-r", "-w", "y"},
    {"r"},
    {"-r", "w", "-y"},
    {"w", "y"},
    {"-w", "-y"},
]


F = set(frozenset(x) for x in conditions)


def negate(str: str):
    if(str.startswith("-")):
        return str[4:]
    else:
        return "-"+str


def ResSolver(F: set):
    todo = F
    new = set()
    while todo:
        for K1 in todo:
            todo = todo-{K1}
            for K2 in F:
                for L in K1:
                    if(negate(L) in K2):
                        R = (K1-{L}).union((K2-{negate(L)}))
                        if R not in F:
                            F = F.union({R})
                            new = new.union({R})
                        if(len(R) == 0):
                            return F
        todo = new
        new = set()
    return F


solveResult = ResSolver(F)
list = list(el for el in list(set((el for el in s)) for s in solveResult))

list.sort(key=len, reverse=True)

print()
pprint.pprint(list)

if(set() in list):
    print("Unsatisfiable")
else:
    print("Satisfiable")

print()
