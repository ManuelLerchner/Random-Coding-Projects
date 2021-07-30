from Vec3 import Point3, Vec3
from Render import ASPECTRATIO
from Ray import Ray
import numpy as np

lookFrom = Point3(0, 1, 2)
lookAt = Point3(0, 1, -10)
vUp = Vec3(0, 1, 0)
aperture = 0.0
distToFocus = 1.2


class Camera:

    def __init__(self, lookFrom: Vec3, lookAt: Vec3, vUp: Vec3, vFov, aspectRatio, aperture, focusDist):

        self.samplesPerPixel = 5
        self.maxDepth = 10

        # FOV
        self.theta = vFov/180*np.pi
        self.h = np.tan(self.theta/2)
        self.viewport_height = 2*self.h
        self.viewport_width = aspectRatio*self.viewport_height

        # Directions
        w = (lookFrom-lookAt).unitVector()
        u = (vUp.cross(w)).unitVector()
        v = w.cross(u)

        self.origin = lookFrom
        self.horizontal = focusDist*self.viewport_width*u
        self.vertical = focusDist*self.viewport_height*v
        self.lowerLeftCorner = self.origin - self.horizontal/2-self.vertical/2-focusDist*w
        self.lensRadius = aperture/2

    def getRay(self, u, v):

        rd = self.lensRadius*Vec3.randomInUnitDisk()
        offset = u*rd.x+v*rd.y

        return Ray(self.origin+offset, self.lowerLeftCorner - self.origin-offset
                   + u * self.horizontal
                   + v * self.vertical)


cam = Camera(lookFrom, lookAt,
             vUp, 60, ASPECTRATIO, aperture, distToFocus)
