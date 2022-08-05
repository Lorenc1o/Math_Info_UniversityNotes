from xml.etree.ElementTree import PI
import numpy as np
import cv2 as cv

import matplotlib.pyplot as plt
import numpy.linalg as la
from collections import deque

from ipywidgets import interactive
import re

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

urlimg = input("Introduce el nombre de la imagen:")
urldata = input("Introduce el nombre del fichero de datos:")

data = open(urldata, "r")
pts = data.read()

# buscamos los puntos en el fichero de texto
ER = "(\((\d*),(\d*)\))"
x = re.findall(ER,pts)

# sacamos la distancia real entre los dos primeros puntos
ER="d12=(\d*)"
y = re.findall(ER,pts)

pReal = np.empty([len(x),2])
puntos2 = []

for i in range(len(x)):
    pReal[i][0] = int(x[i][1])
    pReal[i][1] = int(x[i][2])
    puntos2.append((int(x[i][1]),int(x[i][2])))

dReal = int(y[0])
dImg = 0
dRealPerPx = 0

img = cv.imread(urlimg)
imgOrig = img.copy()

pImage = np.empty([len(x),2])
puntos = []
nPts = 0

dist = 0
pdist = deque(maxlen=2)
# cada vez que clickamos en un punto, lo añadimos, hasta tener
# tantos como los proporcionados en el txt
def mouse_handler(event, x, y, flags, params):
    #Si detectamos un doble click
    if event == cv.EVENT_LBUTTONDBLCLK:
        global pImage, nPts
        if nPts<len(pReal):
            puntos.append((x,y))
            pImage[nPts][0] = x
            pImage[nPts][1] = y
            cv.circle(img, (x,y), 2, (0,0,255),-1)
            nPts +=1
        elif done:
            pdist.append((x,y))
    return

cv.namedWindow("img")
cv.setMouseCallback("img", mouse_handler)

done = False

while True:
   key = cv.waitKey(1) & 0xFF
   if key == 27: break

   if nPts==len(pReal) and not done:
       tam = img.shape
       blank = np.zeros(tam, dtype=np.uint8)
       blank2 = np.zeros(tam, dtype=np.uint8)
       for i in range(nPts-1):
            cv.circle(blank, puntos[i], 2, (0,0,255),-1)
            cv.line(blank, puntos[i],puntos[i+1],(0,0,255))
            cv.circle(blank2, puntos2[i], 2, (0,0,255),-1)
            cv.line(blank2, puntos2[i],puntos2[i+1],(0,0,255))
       cv.circle(blank, puntos[nPts-1], 2, (0,0,255),-1)
       cv.line(blank, puntos[-1],puntos[0],(0,0,255))
       cv.circle(blank2, puntos2[nPts-1], 2, (0,0,255),-1)
       cv.line(blank2, puntos2[-1],puntos2[0],(0,0,255))
       done = True

       # obtenemos la transformación para llevar la imagen al modelo
       H,_ = cv.findHomography(pImage,pReal)
       
       # calculamos la nueva imagen reconstruida
       fin = cv.warpPerspective(imgOrig, H, (tam[1],tam[0]))
       finOrig = fin.copy()
   cv.imshow("img",img)

   if done:
       fin = finOrig.copy()
       for p in pdist:
           p2 = htrans(H,p)
           p2 = p2int(p2)
           cv.circle(fin, p2, 3, (0,0,255),-1)
       if len(pdist)==2:
           dist = d(htrans(H,pdist[0]),htrans(H,pdist[1]))
           cv.line(fin, p2int(htrans(H,pdist[0])),p2int(htrans(H,pdist[1])),(0,0,255),1)

       if len(pdist)==2:
           dImg = d(htrans(H,pImage[0]),htrans(H,pImage[1]))
           dRealPerPx = dReal/dImg
           cv.putText(fin, str(dist*dRealPerPx), (tam[1]//2,tam[0]//2), cv.FONT_HERSHEY_SIMPLEX, 1, (0,0,255))
       cv.imshow("blank2",blank2)
       cv.imshow("blank",blank)
       cv.imshow("fin", fin)


