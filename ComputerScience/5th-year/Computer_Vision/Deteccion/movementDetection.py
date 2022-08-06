#!/usr/bin/env python

import numpy as np
import cv2 as cv

from umucv.util import ROI, putText
from umucv.stream import autoStream
from umucv.util import Video
from datetime import datetime


cv.namedWindow("input")
cv.moveWindow('input', 0, 0)

region = ROI("input")

def bgr2gray(x):
    return cv.cvtColor(x,cv.COLOR_BGR2GRAY).astype(float)

trozoFix = []
X1=X2=Y1=Y2=-1
detected = False
media = 0
frames = 0
secs = 3
video = Video(fps=20, codec="MJPG",ext="avi")

for key, frame in autoStream():
    #Añadimos fecha y hora a la imagen para saber cuándo nos intentaron robar
    now = datetime.now()
    time = now.strftime("%d/%m/%Y %H:%M:%S")
    cv.putText(frame, time, (8, 16), cv.FONT_HERSHEY_SIMPLEX, 0.5, (255,255,255))

    #Procesamos en B&W
    frameBYN = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)

    #Si estamos en proceso de grabación, añadimos el frame actual al vídeo
    if frames>0 and frames<20*secs:
        frames += 1
        video.write(frame)
    else:
        frames = 0

    if region.roi:
        [x1,y1,x2,y2] = region.roi
        trozo = frameBYN[y1:y2+1, x1:x2+1]

        #Si pulsamos la c empieza la detección en la zona seleccionada
        if key == ord('c'):
            if X1>=0:
                X1=X2=Y1=Y2=-1
                cv.destroyWindow("trozo")
                if detected:
                    cv.destroyWindow("deteccion")
                    detected = False
            X1=x1
            X2=x2
            Y1=y1
            Y2=y2
            trozoFix = frameBYN[Y1:Y2+1, X1:X2+1]
            cv.imshow("trozo", trozoFix)
        #Si pulsamos la x salimos de la detección
        if key == ord('x'):
            region.roi = []
            trozoFix = []
            if X1>=0:
                X1=X2=Y1=Y2=-1
                cv.destroyWindow("trozo")
                if detected:
                    cv.destroyWindow("deteccion")
                    detected = False

        if(X1>=0):
            trozoNew = frameBYN[Y1:Y2+1, X1:X2+1]
            #Calculamos la media de la diferencia absoluta entre la imagen actual y la fija
            media = np.mean(cv.absdiff(trozoNew, trozoFix))
            #Un valor arbitrario que funciona decentemente
            if media >= 15:
                #Si no estamos grabando
                if frames == 0:
                    frames = 1
                    video.ON = True
                    detected = True
                    cv.namedWindow("deteccion")
                cv.imshow("deteccion", cv.absdiff(trozoNew, trozoFix))
            #Si hemos terminado de grabar y no hace falta seguir haciéndolo
            elif detected == True and frames == 0:
                cv.destroyWindow("deteccion")
                detected = False
            cv.imshow("trozo", trozoFix)

        #Ponemos el rectángulo, con el tamaño y la media de la diferencia
        cv.rectangle(frame, (x1,y1), (x2,y2), color=(0,255,255), thickness=2)
        putText(frame, f'{x2-x1+1}x{y2-y1+1}', orig=(x1,y1-8))
        putText(frame, f'{media:.2f}', orig=(x1,y2+16))

    cv.imshow('input',frame)
cv.destroyAllWindows()
video.release()
