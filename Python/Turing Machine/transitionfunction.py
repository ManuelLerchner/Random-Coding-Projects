class TransitionFunction:

    def __init__(self, possibleInputs: set):
        self.possibleInputs = possibleInputs
        self.transitionFunction = {i: None for i in self.possibleInputs}

    def addTuple(self, input: tuple, outputs: tuple):
        if input in self.possibleInputs:
            self.transitionFunction[input] = outputs
        else:
            print("Enter valid input", input, "was not accepted")

    def addStateTable(self, ST: str):
        for line in ST.split("\n"):
            S = line.replace("\t", " ").split(" ")
            S = [x for x in S if x]
            if len(S) == 6:

                currState, scannedSymbol, arrow, newSymbol, newState, dir = S
                self.addTuple((currState, scannedSymbol),
                              (newSymbol, newState, dir))

    def find(self, input: tuple):
        return self.transitionFunction[input]

    def __repr__(self):
        return str(self.transitionFunction)
