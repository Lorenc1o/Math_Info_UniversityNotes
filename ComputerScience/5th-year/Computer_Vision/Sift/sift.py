#!/usr/bin/env python

# eliminamos muchas coincidencias erróneas mediante el "ratio test"

import cv2 as cv
import time
import os
import matplotlib.pyplot as plt

from umucv.stream import autoStream
from umucv.util import putText

sift = cv.SIFT_create(nfeatures=500)

matcher = cv.BFMatcher()

x0 = None

modelos = []
kpModelos = []
descModelos = []

for img in os.listdir("modelos"):
    model = cv.imread(os.path.join("modelos", img))
    modelos.append(model)

    kp, desc = sift.detectAndCompute(model, mask=None)

    kpModelos.append(kp)
    descModelos.append(desc)

state = 0
matched = False

for key, frame in autoStream():

    if key == ord('x'):
        x0 = None
        if matched:
            cv.destroyWindow("model")
        state = 0

    t0 = time.time()
    keypoints , descriptors = sift.detectAndCompute(frame, mask=None)
    t1 = time.time()
    putText(frame, f'{len(keypoints)} pts  {1000*(t1-t0):.0f} ms')

    if key == ord('c'):
        state = 1
        k0, d0, x0 = keypoints, descriptors, frame

    if x0 is None:
        flag = cv.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS
        cv.imshow('SIFT', frame)
    else:
        t2 = time.time()
        # solicitamos las dos mejores coincidencias de cada punto, no solo la mejor
        # tomamos el mejor modelo
        if state==1:
            bestModel = 0
            bestMatch = []
            bestPerc = 0 #el mejor porcentaje de matches hasta ahora
            for i in range(len(modelos)):
                matches = matcher.knnMatch(descModelos[i], d0, k=2)

                # ratio test
                # nos quedamos solo con las coincidencias que son mucho mejores que
                # que la "segunda opción". Es decir, si un punto se parece más o menos lo mismo
                # a dos puntos diferentes del modelo lo eliminamos.
                good = []
                for m in matches:
                    if len(m) >= 2:
                        best,second = m
                        if best.distance < 0.75*second.distance:
                            good.append(best)

                if len(good)/len(matches) > bestPerc:
                    bestModel = i
                    bestPerc = len(good)/len(kpModelos[i])
                    bestMatch = good
                print("para la imagen " + str(i) + " sale " + str(len(good)/len(kpModelos[i])))    

        
        t3 = time.time()

        cv.imshow("SIFT",frame)
        if bestPerc > 0.2:
            matched = True
            cv.imshow("model",modelos[bestModel])
        elif matched:
            cv.destroyWindow("model")
            matched = False

        state = 0


