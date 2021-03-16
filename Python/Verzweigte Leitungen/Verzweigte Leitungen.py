import numpy as np


class Node:

    def __init__(self, name):
        self.name = name
        self.drainedCurrent = 0
        self.child = None
        self.len = 0

    def __str__(self):
        chain = ""
        vertical = ""
        current = ""
        running = self

        previous = None

        while running is not None:
            segment = "-----" + (str(running.len)+"m" if running !=
                                 self else "") + "-----"+running.name
            chain += segment

            if(running != self):
                vertical += (len(segment)-1)*" "+"|"
                current += ((len(segment)-1)-len(str(previous.drainedCurrent)
                                                 )+1)*" "+str(running.drainedCurrent)
            else:
                vertical += (len(segment)-1)*" "+" "
                current += (len(segment)-1)*" "+" "

            previous = running
            running = running.child

        out = chain+2*("\n"+vertical)+"\n"+current

        return out

    def connect(self, parent, len):
        self.parent = parent
        parent.child = self
        self.len = len

    def drain(self, val):
        self.drainedCurrent += val

    def calcDeltaU(self, gamma, A, cosPhi):
        running = self.child
        cummulativeLen = 0
        sumIL = 0

        while running is not None:
            cummulativeLen += running.len
            sumIL += cummulativeLen*running.drainedCurrent
            running = running.child

        return 2*sumIL*cosPhi/(gamma*A)

    def calcPv(self, gamma, A, cosPhi):
        sumIIl = 0
        myStart = self.child

        while myStart is not None:

            running = myStart
            cummulativeCurr = 0

            while running is not None:
                cummulativeCurr += running.drainedCurrent
                running = running.child

            sumIIl += cummulativeCurr*cummulativeCurr*myStart.len

            myStart = myStart.child

        return 2*sumIIl/(gamma*A)

    def calcPvPercent(self, gamma, A, cosPhi, U):
        PV = self.calcPv(gamma, A, cosPhi)
        sumIL = 0
        running = self.child
        cummulativeCurr = 0

        while running is not None:
            cummulativeCurr += running.drainedCurrent
            running = running.child

        PTotal = U*cummulativeCurr*cosPhi

        return 100*PV/PTotal


# Nodes
N0 = Node("S0")
A = Node("A")
B = Node("B")
C = Node("C")
D = Node("D")
E = Node("E")
F = Node("F")


# Connect
A.connect(N0, 12)
B.connect(A, 5)
C.connect(B, 5)
D.connect(C, 5)
E.connect(D, 5)
F.connect(E, 5)


# Current
A.drain(3)
B.drain(3)
C.drain(3)
D.drain(3)
E.drain(3)
F.drain(3)

print(N0)

###############
U = 230
gamma = 56
A = 1.5
cosPhi = 0.4
###############


Pperc = N0.calcPvPercent(gamma=gamma, A=A, cosPhi=cosPhi, U=U)
PV = N0.calcPv(gamma=gamma, A=A, cosPhi=cosPhi)

deltaU = N0.calcDeltaU(gamma=gamma, A=A, cosPhi=cosPhi)
deltaUPerc = deltaU / U*100

print("Pv = ", np.round(PV, decimals=5), "W")
print("Pv% = ", np.round(Pperc, decimals=5), "%")

print("deltaU = ", np.round(deltaU, decimals=5), "V")
print("deltaU% = ", np.round(deltaUPerc, decimals=5), "%")
