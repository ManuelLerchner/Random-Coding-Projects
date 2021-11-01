class Memory:

    def __init__(self, Controll_Unit, len=2**5, ):
        self.length = len
        self.memory = [0]*self.length
        self.Controll_Unit = Controll_Unit

    def __repr__(self):
        return str(self.memory)

    def load(self):
        self.Controll_Unit.MDR = self.memory[int(self.Controll_Unit.MAR)]

    def write(self):
        self.memory[int(self.Controll_Unit.MAR)] = self.Controll_Unit.MDR
