import numpy as np
import sympy as sp


points = []

points.append((4, 4))
points.append((4, -3))
points.append((-6, 4))
points.append((-4, -4))
points.append((-0, 1))


matrix = np.zeros((6, 6))


for i, p in enumerate(points):
    matrix[i+1] = np.array([p[0]*p[0], p[1]*p[1], p[0] *
                            p[1], p[0], p[1], 1])


x, y = sp.symbols('x,y')


Variables = sp.Matrix([[x*x, y*y, x*y, x, y, 1],
                       [0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0]])


H = sp.Matrix(matrix)+Variables

det = H.det()


range = 10

p1 = sp.plot_implicit(sp.Eq(det, 0), (x, -range, range),
                      (y, -range, range), show=False, depth=1, points=1000, size=(8, 8))


for p in points:
    p2 = sp.plot_implicit((x-p[0])**2+(y-p[1])**2 < 0.02, (x, -range, range),
                          (y, -range, range), show=False, depth=1, points=1000, line_color="red")
    p1.append(p2[0])

p1.show()

print(det)
print(p1)
