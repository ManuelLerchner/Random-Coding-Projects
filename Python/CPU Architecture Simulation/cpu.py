from memory import Memory
from controll_unit import Controll_Unit
from arithmetic_logical_unit import ALU


class CPU:

    def __init__(self, PROGRAMM, DATA):
        (programmstart, programm) = PROGRAMM
        (datastart, data) = DATA

        self.Controll_Unit = Controll_Unit()
        self.Memory = Memory(self.Controll_Unit)
        self.ALU = ALU(self.Controll_Unit)

        programm = list(filter(bool, programm.split('\n')))
        data = list(filter(bool, data.split('\n')))

        self.data = data
        self.programm = programm

        for (i, line) in enumerate(programm):
            self.Memory.memory[i+programmstart] = line

        for (i, datum) in enumerate(data):
            self.Memory.memory[i+datastart] = datum

        self.Controll_Unit.PC=programmstart

    def run(self):

        while(True):

            self.Controll_Unit.MAR = self.Controll_Unit.PC  # Programm Counter --> MAR

            self.Memory.load()  # fetch into MDR

            if(self.Controll_Unit.MDR == "RET"):
                return

            self.Controll_Unit.IR = self.Controll_Unit.MDR  # move into MDR

            self.Controll_Unit.PC += 1  # inc PC

            # decode | conenct circuits in cpu
            self.decodeANDexecute(self.Controll_Unit.IR)

    def decodeANDexecute(self, command):

        commandParts = command.split(" ")
        command = commandParts[0]
        agruments = commandParts[1:]

        if command == "MOV":

            target = str(agruments[0])
            source = str(agruments[1])

            self.Controll_Unit.MAR = source

            if(source.isnumeric()):
                self.Memory.load()
            else:
                self.ALU.load()

            self.Controll_Unit.MAR = target

            if(target.isnumeric()):
                self.Memory.write()
            else:
                self.ALU.write()

        if command == "ADD":

            target = "AX"
            source = str(agruments[0])

            self.Controll_Unit.MAR = source

            if(source.isnumeric()):
                self.Memory.load()
            else:
                self.ALU.load()

            self.ALU.add()
