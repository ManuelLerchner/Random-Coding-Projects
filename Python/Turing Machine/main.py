
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
