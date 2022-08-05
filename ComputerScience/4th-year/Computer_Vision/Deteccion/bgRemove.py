#!/usr/bin/env python

from cv2 import RETR_EXTERNAL
import numpy as np
import cv2 as cv

from umucv.util import ROI, putText
from umucv.stream import autoStream

#Creamos un filtro de eliminación de fondo, entre los que he probado el que usa KNN es el que mejor me funciona
fgbg = cv.createBackgroundSubtractorKNN()
 
for key, frame in autoStream():
    k = cv.waitKey(30) & 0xff
    if k == 27:
        break
    
    #Creamos la máscara aplicando el filtro al frame actual
    fgmask = fgbg.apply(frame)
    #Buscamos el contorno del foreground
    cont = cv.findContours(fgmask, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)[-2]

    #Creamos una máscara que podamos multiplicar por el frame actual (tamaños coincidentes)
    mask = np.zeros_like(frame)
    todos = -1
    on = (1,1,1)
    relleno = -1
    #Le ponemos el contorno calculado antes
    cv.drawContours(mask, cont, todos, on, relleno) 

    #Dibujamos las tres imágenes
    cv.imshow('fgmask', fgmask)
    cv.imshow('frame',frame)
    cv.imshow("final",mask*frame)
     
cv.destroyAllWindows()