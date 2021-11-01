
from cpu import CPU


# Adds all elemts of 'data', puts result in adress 20, stores inbetween values in registers
programm = (1, """
MOV AX 10
ADD 11
MOV BX AX
ADD 12
MOV CX AX
ADD 13
MOV 20 AX
RET
""")

data = (10, """
1
2
3
5
""")

myCPU = CPU(programm, data)
myCPU.run()


print(myCPU.Memory)
print(myCPU.ALU)
