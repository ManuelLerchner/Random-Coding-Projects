from math import atan2, log, e, hypot
import random
import matplotlib.pyplot as plt
import timing


'''
 Click to add Point, Keypress to delete nearest point
'''

amountPoints = 1000
rangePar = 100000
checks = 0

pts = list([
	           random.gauss(0, 2 * rangePar) + random.uniform(-rangePar, rangePar),
	           random.gauss(0, 2 * rangePar) + random.uniform(-rangePar, rangePar)] for _ in range(amountPoints))
PointsTuples = HullTuples = []


def GrahamScan(points):
	global checks

	def isLeft(A, B, C):
		return (B[0] - A[0]) * (C[1] - A[1]) - (C[0] - A[0]) * (B[1] - A[1])

	ptStart = min(points, key=lambda t: (t[1], -t[0]))
	points.sort(key=lambda pt: atan2((pt[1] - ptStart[1]), (pt[0] - ptStart[0])))

	Stack = [points[0], points[1]]

	i = 2

	while i < len(points):
		Pt1 = Stack[-1]
		Pt2 = Stack[-2]

		if len(Stack) == 2 or isLeft(Pt2, Pt1, points[i]) > 0:
			Stack.append(points[i])
			i += 1
		else:
			Stack.remove(Pt1)
		checks += 1

	return Stack


def onclick(MouseEvent):
	global checks
	x = MouseEvent.xdata
	y = MouseEvent.ydata
	if x is not None and y is not None:
		pts.append([x, y])
		checks = 0
		update()


def onButton(MouseEvent):
	global checks
	x = MouseEvent.xdata
	y = MouseEvent.ydata
	if x is not None and y is not None:
		if len(pts) > 2:
			pclosest = min(pts, key=lambda t: (hypot(t[0] - x, t[1] - y)))
			pts.remove(pclosest)
			checks = 0
			update()


def update():
	global PointsTuples, HullTuples
	timing.start = timing.time()
	ConvexHull = GrahamScan(pts)
	PointsTuples = [(x, y) for x, y in pts]
	HullTuples = [(x, y) for x, y in ConvexHull]
	HullTuples.append(HullTuples[0])
	print("Convex Hull contains:", len(ConvexHull), "Points")
	print("Calculating took:", checks, "Checks", "(BigO: n*log(n):", "~" + str(round(0.1447 * amountPoints * log(amountPoints, e), 3)) + ")")
	timing.log("Calculation Finished")


update()
fig, ax = plt.subplots()
cid = fig.canvas.mpl_connect('button_press_event', onclick)
cid = fig.canvas.mpl_connect('key_press_event', onButton)

# Plot
while True:
	ax.fill(*zip(*HullTuples), facecolor='lightsalmon', alpha=0.8, edgecolor='orangered', linewidth=2)
	ax.plot(*zip(*PointsTuples), "bo")
	ax.axis("off")
	plt.pause(0.05)
	ax.clear()

plt.show()
