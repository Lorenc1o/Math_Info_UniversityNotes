#!/usr/bin/env python

import cv2   as cv
import numpy as np
from umucv.stream import autoStream
import keyboard
from umucv.util import Help, ROI, putText
import scipy.ndimage as fil

def nada(v):
    pass

#Creamos un ROI
cv.namedWindow("binary")
region = ROI("binary")

#Creamos los trackbar
cv.createTrackbar("sigma", "binary", 1, 100, nada)
cv.createTrackbar("radius", "binary", 1, 10, nada)

#Inicializamos el estado a 0
mode = 0

#Inicializamos only roi a false
roi = False
X1=X2=Y1=Y2=0

#Inicializamos color a true
color = True

help = Help(
"""
HELP

0: do nothing
1: gaussian filter
2: box filter
3: median blur
4: bilateral filter
5: min
6: max

c: color/monochrome
r: only roi
""")

for key, frame in autoStream():
    k = cv.waitKey(1) & 0xFF
    if k == 27:      
        break
    help.show()

    #Si no se ha seleccionado la opción de roi, entonces se toman las coordenadas de la imagen completa
    if not roi:
        X1=Y1=0
        Y2,X2,_ = frame.shape

    #Si se ha seleccionado la opción de monocromo, transformamos el fragmento de imagen procesado a escala de grises
    if not color and (X1<X2 and Y1<Y2):   
        frame[Y1:Y2,X1:X2] = cv.cvtColor(cv.cvtColor(frame[Y1:Y2,X1:X2], cv.COLOR_BGR2GRAY), cv.COLOR_GRAY2BGR)

    #Obtenemos el trackbar
    h = cv.getTrackbarPos('sigma','binary')
    r = cv.getTrackbarPos('radius','binary')

    #Si seleccionamos gaussian filter, lo aplicamos al fragmento procesado
    if(mode == 1 and (X1<X2 and Y1<Y2)):
        frame[Y1:Y2,X1:X2] = cv.GaussianBlur(frame[Y1:Y2,X1:X2], (0,0), max(h,1))
    #Si seleccionamos box filter
    elif(mode == 2 and (X1<X2 and Y1<Y2)):
        frame[Y1:Y2,X1:X2] = cv.boxFilter(frame[Y1:Y2,X1:X2], -1, (max(h,1),max(h,1)))
    elif(mode == 3 and (X1<X2 and Y1<Y2)):
        if h%2 == 0:
            h += 1
        frame[Y1:Y2,X1:X2] = cv.medianBlur(frame[Y1:Y2,X1:X2], max(h,1))
    elif(mode == 4 and (X1<X2 and Y1<Y2)):
        frame[Y1:Y2,X1:X2] = cv.bilateralFilter(frame[Y1:Y2,X1:X2], 0, max(r,1),max(r,1))
    elif(mode == 5 and (X1<X2 and Y1<Y2)):
        frame[Y1:Y2,X1:X2,0] = fil.minimum_filter(frame[Y1:Y2,X1:X2,0], max(h,1))
        frame[Y1:Y2,X1:X2,1] = fil.minimum_filter(frame[Y1:Y2,X1:X2,1], max(h,1))
        frame[Y1:Y2,X1:X2,2] = fil.minimum_filter(frame[Y1:Y2,X1:X2,2], max(h,1))
    elif(mode == 6 and (X1<X2 and Y1<Y2)):
        frame[Y1:Y2,X1:X2,0] = fil.maximum_filter(frame[Y1:Y2,X1:X2,0], max(h,1))
        frame[Y1:Y2,X1:X2,1] = fil.maximum_filter(frame[Y1:Y2,X1:X2,1], max(h,1))
        frame[Y1:Y2,X1:X2,2] = fil.maximum_filter(frame[Y1:Y2,X1:X2,2], max(h,1))
    else:
        mode = 0
    
    #Se cambia el estado en función de la selección
    if(k == 48):
        mode = 0
        roi = False
        color = True
    elif(k == 49):
        mode = 1
    elif(k == 50):
        mode = 2
    elif(k == 51):
        mode = 3
    elif(k == 52):
        mode = 4
    elif(k == 53):
        mode = 5
    elif(k == 54):
        mode = 6
    elif(k ==  99):
        color = not color
    elif(k == 114):
        roi = not roi

    if region.roi:
        [x1,y1,x2,y2] = region.roi
        #Si se ha seleccionado la opción de roi, se toman las coordenadas oportunas del fragmento a procesar
        if roi:
            X1=x1
            X2=x2
            Y1=y1
            Y2=y2
        cv.rectangle(frame, (x1,y1), (x2,y2), color=(0,255,255), thickness=2)
    putText(frame, "mode = " + f'{mode}', orig = (8,16))
    if not color:
        putText(frame, "B&W", orig = (8,35))
    if roi:
        putText(frame, "ROI", orig = (8, 54))
    cv.imshow('binary', frame)

cv.destroyAllWindows()

