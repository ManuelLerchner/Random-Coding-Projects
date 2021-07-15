
from turingmachine import TuringMachine
from transitionfunction import TransitionFunction
from itertools import product


StateTable = """
s1	1	→	0	s2	R
s1	0	→	0	s6	N
s2	1	→	1	s2	R
s2	0	→	0	s3	R
s3	1	→	1	s3	R
s3	0	→	1	s4	L
s4	1	→	1	s4	L
s4	0	→	0	s5	L
s5	1	→	1	s5	L
s5	0	→	1	s1	R
"""

Q = {"s1", "s2", "s3", "s4", "s5", "s6"}
Σ = {"1"}
Γ = {"1", "0"}
q0 = "s1"
b = "0"
F = {"s6"}

δ = TransitionFunction(set(product(Q.difference(F), Γ)))
δ.addStateTable(StateTable)

TM = TuringMachine(Q, Σ, Γ, δ, q0, b, F)

TM.Tape.setValues("1111")
TM.run()
TM.render("Double")

############################

StateTable2 = """ 
A	0	→	1	B   R
A	1	→	1	C   L
B	0	→	1	A   L
B	1	→	1	B   R
C	0	→	1	B   L
C	1	→	1	H   N
"""

Q = {"A", "B", "C", "H"}
Σ = {"1"}
Γ = {"1", "0"}
q0 = "A"
b = "0"
F = {"H"}

δ = TransitionFunction(set(product(Q.difference(F), Γ)))
δ.addStateTable(StateTable2)

TM = TuringMachine(Q, Σ, Γ, δ, q0, b, F)

TM.Tape.setValues("")
TM.run()
TM.render("Busy Beaver")

############################

StateTable3 = """ 
right   0   →   0   right   R
right   1   →   1   right   R
right   +   →   +   right   R
right   _   →   _   read    L

read   0   →   c   have0    L
read   1   →   c   have1    L
read   +   →   _   rewrite  L

have0   0   →   0   have0   L
have0   1   →   1   have0   L
have0   +   →   +   add0    L

have1   0   →   0   have1   L
have1   1   →   1   have1   L
have1   +   →   +   add1    L

add0    0   →   O   back0   R
add0    _   →   O   back0   R
add0    1   →   I   back0   R
add0    O   →   O   add0    L
add0    I   →   I   add0    L

add1    0   →   I   back1   R
add1    _   →   I   back1   R
add1    1   →   O   carry   L
add1    O   →   O   add1    L
add1    I   →   I   add1    L

carry   0   →   1   back1   R
carry   _   →   1   back1   R
carry   1   →   0   carry   L

back0   0   →   0   back0   R 
back0   1   →   1   back0   R 
back0   O   →   O   back0   R 
back0   I   →   I   back0   R 
back0   +   →   +   back0   R 
back0   c   →   0   read    L 

back1   0   →   0   back1   R 
back1   1   →   1   back1   R 
back1   O   →   O   back1   R 
back1   I   →   I   back1   R 
back1   +   →   +   back1   R 
back1   c   →   1   read    L 

rewrite O   →   0   rewrite L
rewrite I   →   1   rewrite L
rewrite 0   →   0   rewrite L
rewrite 1   →   1   rewrite L  
rewrite _   →   _   done R
"""

Q = {"right", "read", "have0", "have1", "add0",
     "add1", "carry", "back0", "back1", "rewrite", "done"}
Σ = {"1", "0", "+"}
Γ = {"1", "0", "+", "c", "_", "I", "O"}
q0 = "right"
b = "_"
F = {"done"}

δ = TransitionFunction(set(product(Q.difference(F), Γ)))
δ.addStateTable(StateTable3)

TM = TuringMachine(Q, Σ, Γ, δ, q0, b, F)

TM.Tape.setValues("101001111+1000001")
TM.run()
TM.render("Binary Add")
