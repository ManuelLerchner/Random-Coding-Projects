class ALU:

    def __init__(self, Controll_Unit):
        self.Registers = {"AX": 0,
                          "BX": 0,
                          "CX": 0}
                          
        self.Controll_Unit = Controll_Unit

    def load(self):
        self.Controll_Unit.MDR = self.Registers.get(self.Controll_Unit.MAR)

    def write(self):
        self.Registers[self.Controll_Unit.MAR] = self.Controll_Unit.MDR

    def add(self):
        self.Registers["AX"] = int(
            self.Registers["AX"])+int(self.Controll_Unit.MDR)

    def __repr__(self):
        return str(self.Registers)
