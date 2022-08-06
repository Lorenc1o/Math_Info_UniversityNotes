from xml.etree.ElementTree import PI
import numpy as np
import cv2 as cv

import matplotlib.pyplot as plt
import numpy.linalg as la
from collections import deque

from ipywidgets import interactive

# convierte un conjunto de puntos ordinarios (almacenados como filas de la matriz de entrada)
# en coordenas homogéneas (añadimos una columna de 1)
def homog(x):
    ax = np.array(x)
    uc = np.ones(ax.shape[:-1]+(1,))
    return np.append(ax,uc,axis=-1)

# convierte en coordenadas tradicionales
def inhomog(x):
    ax = np.array(x)
    return ax[..., :-1] / ax[...,[-1]]

# aplica una transformación homogénea h a un conjunto
# de puntos ordinarios, almacenados como filas
def htrans(h,x):
    return inhomog(homog(x) @ h.T)

# distancia entre dos puntos
def d(x, y):
    return np.sqrt((x[0]-y[0])**2+(x[1]-y[1])**2)

# función que nos devuelve un punto de pixels enteros
def p2int(p):
    return (int(p[0]),int(p[1]))

# función que pasa un array de puntos a un array numpy
def p2np(pts):
    return np.array(pts, 'int32')

#funcion que nos devuelve el mínimo de un conjunto de puntos en 
#la dimensión buscada
def min(pts, dim):
    m = 1e12
    for pt in pts:
        if pt[dim]<m:
            m=pt[dim]
    return m

#funcion que nos devuelve el máximo de un conjunto de puntos en 
#la dimensión buscada
def max(pts, dim):
    m = -1e12
    for pt in pts:
        if pt[dim]>m:
            m=pt[dim]
    return m

urlimg = input("Introduce el nombre de la imagen:")

img = cv.imread(urlimg)
imgOrig = img.copy()

pImage = np.empty([4,2])
puntos = []

pImage2 = np.empty([4,2])
puntos2 = []

nPts = 0

dist = 0
# cada vez que clickamos en un punto, lo añadimos, hasta tener
# tdos cuádrilateros
def mouse_handler(event, x, y, flags, params):
    #Si detectamos un doble click
    if event == cv.EVENT_LBUTTONDBLCLK:
        global pImage, nPts
        if nPts<4:
            puntos.append((x,y))
            pImage[nPts][0] = x
            pImage[nPts][1] = y
            cv.circle(img, (x,y), 2, (0,0,255),-1)
            nPts +=1
        elif 4<=nPts<8:
            puntos2.append((x,y))
            pImage2[nPts-4][0] = x
            pImage2[nPts-4][1] = y
            cv.circle(img, (x,y), 2, (0,0,255),-1)
            nPts +=1
    return

cv.namedWindow("img")
cv.setMouseCallback("img", mouse_handler)

done = False

while True:
   key = cv.waitKey(1) & 0xFF
   if key == 27: break

   if nPts==8 and not done:
       tam = img.shape
       done = True

       # obtenemos la transformación para llevar la imagen al modelo
       H,_ = cv.findHomography(pImage,pImage2)
       
       puntosH = []
       for p in puntos:
           puntosH.append(p2int(htrans(H,p)))
       puntosH = p2np(puntosH)

       H2,_ = cv.findHomography(pImage2, pImage)

       puntosH2 = []
       for p in puntos2:
           puntosH2.append(p2int(htrans(H2,p)))
       puntosH2 = p2np(puntosH2)
       
       # calculamos la nueva imagen reconstruida
       fin = cv.warpPerspective(imgOrig, H, (tam[1],tam[0]))
       fin2 = cv.warpPerspective(imgOrig, H2, (tam[1],tam[0]))

       mask1 = np.zeros((tam[0],tam[1]))
       cv.fillConvexPoly(mask1, puntosH, 1)
       mask1 = mask1.astype(np.bool)
       mask2 = np.zeros((tam[0],tam[1]))
       cv.fillConvexPoly(mask2, puntosH2, 1)
       mask2 = mask2.astype(np.bool)

       res = imgOrig.copy()
       res[mask1] = fin[mask1]
       res[mask2] = fin2[mask2]

       finOrig = fin.copy()
   cv.imshow("img",img)

   if done:
    cv.imshow("res", res)


