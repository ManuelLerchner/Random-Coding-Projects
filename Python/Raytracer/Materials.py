from matplotlib.pyplot import scatter
from Ray import Ray
from Vec3 import Color, Vec3, Point3
import numpy as np


class HitRecord:
    def __init__(self, pos: Point3, t, material):
        self.pos = pos
        self.normal = None
        self.t = t
        self.material = material

    def setFaceNormal(self, ray: Ray, outwardNormal: Vec3):
        self.frontFace = ray.direction.dot(outwardNormal) < 0
        self.normal = outwardNormal if self.frontFace else outwardNormal*(-1)


class Material:
    def __init__(self, col: Color):
        pass

    def scatter(self, ray: Ray, hr: HitRecord):
        pass


class lambertianMaterial(Material):

    def __init__(self, col: Color):
        self.col = col

    def scatter(self, ray: Ray, hr: HitRecord):
        scatterDir = hr.normal+Vec3.randomInUnitSphere()

        if scatterDir.nearZero():
            scatterDir = hr.normal

        scattered = Ray(hr.pos, scatterDir)
        attenuation = self.col
        return scattered, attenuation

    def __repr__(self):
        return f"Lambert col={self.col}"


class Metal(Material):

    def __init__(self, col: Color, fuzz):
        self.col = col
        self.fuzz = fuzz

    def scatter(self, ray: Ray, hr: HitRecord):
        reflected = ray.direction.unitVector().reflectNormal(hr.normal)
        scattered = Ray(hr.pos, reflected+Vec3.randomInUnitSphere()*self.fuzz)

        attenuation = self.col

        if scattered.direction.dot(hr.normal) < 0:
            return None, None

        return scattered, attenuation

    def __repr__(self):
        return f"Metal col={self.col}, fuzz={self.fuzz}"


class Dielectric(Material):

    def __init__(self, indexOfRefraction):
        self.indexOfRefraction = indexOfRefraction

    def scatter(self, ray: Ray, hr: HitRecord):
        attenuation = Color(1, 1, 1)

        refractionRatio = 1/self.indexOfRefraction if hr.frontFace else self.indexOfRefraction

        unitDir = ray.direction.unitVector()

        cosTheta = min((unitDir*(-1)).dot(hr.normal), 1)
        sinTheta = (1-cosTheta**2)**0.5

        cannotRefract = refractionRatio*sinTheta > 1

        if cannotRefract or self.reflectance(cosTheta, refractionRatio) > np.random.uniform():
            direction = unitDir.reflectNormal(hr.normal)
        else:
            direction = unitDir.refractSnell(hr.normal, refractionRatio)

        scattered = Ray(hr.pos, direction)

        return scattered, attenuation

    def reflectance(self, cos, refIdx):
        r0 = ((1-refIdx)/(1+refIdx))**2
        return r0+(1-r0)*(1-cos)**5

    def __repr__(self):
        return f"Dielectric refraction={self.indexOfRefraction}"
