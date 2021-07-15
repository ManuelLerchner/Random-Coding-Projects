from util import formatColor
from colorama.ansi import Fore


class Tape:

    def __init__(self, blankSymbol, initialLength=25):
        self.blankSymbol = blankSymbol
        initialSize = 2*initialLength+1
        self.tape = [blankSymbol]*initialSize
        self.idx = 10

    def setValues(self, list):
        for i in range(len(list)):
            if self.idx+i == len(self.tape):
                self.tape.append(list[i])
            else:
                self.tape[self.idx+i] = list[i]

    def writeSymbol(self, symbol):
        self.tape[self.idx] = symbol

    def readSymbol(self):
        return self.tape[self.idx]

    def move(self, dir: str):
        if dir == "R":
            if self.idx == len(self.tape)-1:
                self.tape.append(self.blankSymbol)
            self.idx += 1
        elif dir == "L":
            if self.idx == 0:
                self.tape.insert(0, self.blankSymbol)
            else:
                self.idx -= 1

    def prettyPrint(self, formatCurrPos=True):
        out = ""
        for i in range(len(self.tape)):
            el = self.tape[i]
            p = formatColor(
                el, '\033[1m'+Fore.YELLOW) if i == self.idx and formatCurrPos else formatColor(
                el, Fore.GREEN)
            out += p

        return out

    def __repr__(self):
        out = ""
        for i in range(len(self.tape)):
            el = self.tape[i]
            p = formatColor(
                el, '\033[1m'+Fore.GREEN)
            out += p

        return out
