from numpy.core.defchararray import center
from Vec3 import Color, Vec3, Point3
from Ray import Ray
from Materials import *


class Sphere:

    def __init__(self, center: Vec3, radius, material):
        self.center = center
        self.radius = radius
        self.material = material

    def hit(self, ray: Ray, tmin, tmax) -> HitRecord:
        oc = ray.origin - self.center
        a = ray.direction.lengthSQ()
        half_b = oc.dot(ray.direction)
        c = oc.lengthSQ() - self.radius**2

        discriminant = half_b*half_b - a*c

        if discriminant < 0:
            return None

        sqrtD = discriminant**0.5

        root = (-half_b-sqrtD)/a
        if root < tmin or root > tmax:
            root = (-half_b+sqrtD)/a
            if root < tmin or root > tmax:
                return None

        pos = ray.at(root)
        outwardNormal = (pos-self.center)/self.radius
        rec = HitRecord(pos, root, self.material)
        rec.setFaceNormal(ray, outwardNormal)

        return rec

    def __repr__(self):
        return "Sphere"


class Objects:

    def __init__(self):
        print("init")
        self.hittableObjects = []
        self.makeRandomScene()

    def add(self, O):
        self.hittableObjects.append(O)

    def hit(self, ray: Ray, tmin, tmax) -> HitRecord:
        closest = tmax
        record = None

        for hittable in self.hittableObjects:
            Hit = hittable.hit(ray, tmin, closest)

            if Hit is not None:
                closest = Hit.t
                record = Hit

        return record

    def __repr__(self):
        out = ""

        for HO in self.hittableObjects:
            out += f" {HO} r={HO.radius}   m={HO.material}\n"

        return out

    def makeRandomScene(self):
        groundMaterial = lambertianMaterial(Color(0.5, 0.5, 0.5))
        GroundSphere = Sphere(Point3(0, -1000, 0), 1000, groundMaterial)
        self.hittableObjects.append(GroundSphere)

        Mat = lambertianMaterial(Color(1, 0.5, 0.2))
        Sphr = Sphere(Point3(0.5, 0.9, 0.4), 0.2, Mat)
        self.hittableObjects.append(Sphr)

        Mat = Metal(Color(1, 0.5, 1), 2)
        Sphr = Sphere(Point3(-1, 0.3, 0), 0.2, Mat)
        self.hittableObjects.append(Sphr)

        Mat = Dielectric(1.5)
        Sphr = Sphere(Point3(0.4, 0.7, 0.6), 0.3, Mat)
        self.hittableObjects.append(Sphr)

        Mat = Metal(Point3(0.8, 0.3, 0.3), 0.6)
        Sphr = Sphere(Point3(1, 1.3, -1.3), 0.2, Mat)
        self.hittableObjects.append(Sphr)

        Mat = lambertianMaterial(Color(0, 0.5, 1))
        Sphr = Sphere(Point3(-0.5, 1.2, 0.3), 0.2, Mat)
        self.hittableObjects.append(Sphr)

        Mat = Metal(Color(0.9, 0.9, 1), 0.1)
        Sphr = Sphere(Point3(0, 1.3, 0.3), 0.4, Mat)
        self.hittableObjects.append(Sphr)

        Mat = Metal(Color(0.3, 1, 0.6), 0.9)
        Sphr = Sphere(Point3(-0.2, 0.7, 0.5), 0.2, Mat)
        self.hittableObjects.append(Sphr)

        print(len(self.hittableObjects), "Objects")


World = Objects()
