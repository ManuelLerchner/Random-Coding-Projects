from Ray import Ray
from Vec3 import Color, Vec3

import Objects
from Camera import cam
from Render import WIDTH, HEIGHT
import numpy as np


def getColor(M):

    u, v = M[0], M[1]

    pixColor = Color(0, 0, 0)

    for _ in range(cam.samplesPerPixel):
        ur = u+np.random.uniform(0, 1/(WIDTH-1))
        vr = v+np.random.uniform(0, 1/(HEIGHT-1))

        ray = cam.getRay(ur, vr)
        pixColor += traceRay(ray, cam.maxDepth)

    return np.sqrt((pixColor/cam.samplesPerPixel).val)


def traceRay(ray: Ray, depth):
    Hit = Objects.World.hit(ray, 0.005, np.Infinity)

    if depth < 0:
        return Color(0,0,0)

    if Hit is not None:
        #target = Hit.pos + Hit.normal + Vec3.randomInUnitSphere()
        #target = Hit.pos + Hit.normal + 1.2*Vec3.random()
        # hemisphere
        #target = Hit.pos + Vec3.randomInUnitHemiSphere(Hit.normal)

        # return traceRay(Ray(Hit.pos, target-Hit.pos), depth-1)*0.5
        # return (Hit.normal+Color(1, 1, 1))*0.5

        scattered, atenuation = Hit.material.scatter(ray, Hit)
        if atenuation is not None:
            return atenuation * traceRay(scattered, depth-1)
        else:
            return Color(0, 0, 0)

    # background
    unitDir = ray.direction.unitVector()
    t = 0.5*(unitDir.y + 1.0)
    return (1.0-t)*Color(1, 1, 1) + t*Color(0.5, 0.7, 1)
