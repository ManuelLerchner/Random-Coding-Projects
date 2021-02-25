
# a x2+  b xy+ c y2+  d x+  e  y f  = 0
import numpy as np
from numpy import linalg

Points = [(1, -2), (0, -1), (2, 0), (-2, 0), (3, 1)]


Vec = [-T[0]*T[0] for T in Points]




Mat = np.zeros((5, 5))



for i in range(0, 5):
    Mat[i][0] = Points[i][0]*Points[i][1]
    Mat[i][1] = Points[i][1]*Points[i][1]
    Mat[i][2] = Points[i][0]
    Mat[i][3] = Points[i][1]
    Mat[i][4] = 1


sol = linalg.solve(Mat, Vec)

print(sol)
