import numpy as np
from numpy.lib.histograms import _hist_bin_sqrt
from numpy.linalg import norm


class Vec3:

    def __init__(self, x, y=None, z=None):
        if y is None and z is None:
            if isinstance(x, Vec3):
                self.val = x.val
            elif isinstance(x, np.ndarray):
                self.val = np.array([x[0], x[1], x[2]])
            else:
                self.val = np.array([x, x, x])
        else:
            self.val = np.array([x, y, z])

    @property
    def x(self):
        return self.val[0]

    @property
    def y(self):
        return self.val[1]

    @property
    def z(self):
        return self.val[2]

    def __add__(self, other):
        other = Vec3(other)
        return Vec3(np.add(self.val, other.val))

    def __sub__(self, other):
        other = Vec3(other)
        return Vec3(self.val-other.val)

    def __rsub__(self, other):
        other = Vec3(other)
        return other.val - self.val

    def __mul__(self, other):
        other = Vec3(other)
        return Vec3(np.multiply(self.val, other.val))

    def __rmul__(self, other):
        other = Vec3(other)
        return other*self

    def __truediv__(self, other):
        other = Vec3(other)
        return Vec3(np.divide(self.val, other.val))

    def length(self):
        return norm(self.val)

    def lengthSQ(self):
        return self.length()**2

    def dot(self, other):
        other = Vec3(other)
        return np.dot(self.val, other.val)

    def cross(self, other):
        other = Vec3(other)
        return Vec3(np.cross(self.val, other.val))

    def unitVector(self):
        return Vec3(self/self.length())

    @staticmethod
    def random():
        return Vec3(np.random.uniform(-1, 1, 3))

    @staticmethod
    def randomRange(min, max):
        return Vec3(np.random.uniform(min, max, 3))

    @staticmethod
    def randomInUnitSphere():
        while True:
            P = Vec3(np.random.uniform(-1, 1, 3))
            if P.lengthSQ() < 1:
                return P

    @staticmethod
    def randomInUnitHemiSphere(normal):
        vec = Vec3.randomInUnitSphere()
        if vec.dot(normal) > 0:
            return vec
        else:
            return vec*(-1)

    @staticmethod
    def randomInUnitDisk():
        while True:
            p = Vec3(np.random.uniform(-1, 1), np.random.uniform(-1, 1), 0)
            if p.lengthSQ() >= 1:
                continue
            return p

    def nearZero(self):
        s = 1e-5
        return abs(self.x) < s and abs(self.y) < s and abs(self.z) < s

    def reflectNormal(self, n):
        return self-2*self.dot(n)*n

    def refractSnell(self, n, etaI_over_etaT):
        cosTheta = min((self*(-1)).dot(n), 1)
        r_out_perp = etaI_over_etaT*(self+n*cosTheta)
        r_out_parallel = n*(-np.sqrt(abs(1-r_out_perp.lengthSQ())))
        return r_out_perp+r_out_parallel

    def __repr__(self):
        return str(self.val)


class Color(Vec3):
    pass


class Point3(Vec3):
    pass
