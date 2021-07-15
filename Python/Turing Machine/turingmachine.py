from tape import Tape
from visualize import visualize


class TuringMachine:

    def __init__(self, Q, Σ, Γ, δ, q0, b, F):
        self.Q = Q
        self.Σ = Σ
        self.Γ = Γ
        self.δ = δ
        self.q0 = q0
        self.b = b
        self.F = F

        self.Tape = Tape(b)
        self.currentState = q0

    def run(self):
        print(" ", self.currentState, self.Tape)

        while True:

            input = (self.currentState, self.Tape.readSymbol())
            output = self.δ.find(input)

            newSymbol, newState, dir = output

            print(newSymbol, newState, self.Tape.prettyPrint())

            self.Tape.writeSymbol(newSymbol)
            self.currentState = newState
            self.Tape.move(dir)

            if newState in self.F:
                break

        print(" ", self.currentState, self.Tape)
        return self.Tape

    def render(self, name):

        visualize(name, self.Q, self.δ, self.F, self.q0)
