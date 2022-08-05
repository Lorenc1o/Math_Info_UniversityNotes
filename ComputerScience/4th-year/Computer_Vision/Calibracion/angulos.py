#!/usr/bin/env python

from math import prod
from cv2 import EVENT_LBUTTONDBLCLK
import numpy as np
import cv2   as cv

import sys
from glob import glob

#Definimos las funciones que vamos a utilizar
def prodEsc(x,y):
    p = 0
    for i in range(0,len(x)):
        p += x[i]*y[i]
    return p

def norm(x):
    return np.sqrt(prodEsc(x,x))

def min(x,y):
    if (x<=y): 
        return x
    return y

#Llevamos un estado: 
#   0: ningún punto seleccionado
#   1: primer punto seleccionado
#   2: ambos puntos seleccionados
state = 0

#El manejador del ratón
def mouse_handler(event, x, y, flags, params):
    #Si detectamos un doble click
    if event == cv.EVENT_LBUTTONDBLCLK:
        global state, p1, p2
        #Si el estado es 0, creamos el punto 1
        if state == 0:
            p1 = np.array([x,y])
            state = 1
        #Si el estado es 1, creamos el punto 2
        elif state == 1:
            p2 = np.array([x,y])
            state = 2
        #Si el estado es 2, volvemos al inicio
        else:
            p1 = np.empty(2)
            p2 = np.empty(2)
            state = 0
    return

#Tomamos la imagen que nos pasan como ruta
url = glob(sys.argv[1])[0]

#Asumo que está hecha con mi cámara
f=3488

#Mostramos la imagen y dejamos marcar los puntos con el ratón
img = cv.imread(url)

p1 = np.empty(2)
p2 = np.empty(2)

#Creamos la ventana
cv.namedWindow("Img")

#Asignamos el manejador
cv.setMouseCallback("Img",mouse_handler) 

#Definimos el punto donde se "encuentra" la cámara
dims = img.shape
C = np.array([dims[1]/2, dims[0]/2, 0])

#Reescalamos la imagen para que sea más cómodo porque es muy grande
factor = 20
dim = (int(dims[1]*factor/100), int(dims[0]*factor/100))
rs = cv.resize(img, dim)

while True:
    key = cv.waitKey(1) & 0xFF
    if key == 27: break

    imgF = rs.copy()

    #Cuando hay algún punto seleccionado, lo mostramos
    if state >= 1:
        cv.circle(imgF, (int(p1[0]), int(p1[1])), 10, (255,0,0))
        cv.putText(imgF, "("+str(int(p1[0]*100/factor))+", "+str(int(p1[1]*100/factor))+")" , (min(int(p1[0]+12), dim[0]-100), int(p1[1])), cv.FONT_HERSHEY_SIMPLEX, 0.5, (255,255,255))
        
        #Si están los dos puntos los mostramos y calculamos el ángulo
        if state == 2:
            cv.circle(imgF, (int(p2[0]), int(p2[1])), 10, (0,255,0))
            cv.putText(imgF, "("+str(int(p2[0]*100/factor))+", "+str(int(p2[1]*100/factor))+")" , (min(int(p2[0]+12), dim[0]-100), int(p2[1])), cv.FONT_HERSHEY_SIMPLEX, 0.5, (255,255,255))
            #Pasamos los puntos a 3D
            cp1 = np.append(p1*100/factor, f) - C
            cp2 = np.append(p2*100/factor, f) - C
            #Calculamos el ángulo
            alpha = np.arccos(prodEsc(cp1, cp2)/(norm(cp1)*norm(cp2)))*360/(2*np.pi)
            cv.putText(imgF, str(alpha), (min(int(p2[0])-8, dim[0]-100), min(int(p2[1])+24, dim[1]-50)), cv.FONT_HERSHEY_SIMPLEX, 0.5, (255,255,255))


    cv.imshow("Img", imgF)

    
