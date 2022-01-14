
import pprint

conditions = """
s t -u
s u 
s -u x
-s t u
-s t -u
-s -u -x
-t u
-t -u x
-t -x
"""


def conditionStringSet(conditions: str):
    lines = conditions.split("\n")
    F = set()
    for line in lines:
        if(line):
            F = F.union({frozenset(line.split(" ")).difference({'', ' '})})
    return F


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


F = conditionStringSet(conditions)

solveResult = ResSolver(F)
list = list(el for el in list(set((el for el in s)) for s in solveResult))

list.sort(key=len, reverse=True)


pprint.pprint(list)

print()
print(F)
print("len:", len(F), "checked:", len(list), "resolvents")
if(set() in list):
    print("Unsatisfiable")
else:
    print("Satisfiable")

print()
