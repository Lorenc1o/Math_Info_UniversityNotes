#!/usr/bin/env python

import cv2 as cv
import numpy as np
from umucv.stream import autoStream
from collections import deque
from umucv.util import ROI, putText

#Función que devuelve los histogramas de cada componente de una imagen BGR
#Usamos 16 bins para el histograma
bins = 16
def histogramas(fr):
    # agrupamos los niveles de cada color en 16 intervalos
    hAzul,bAzul = np.histogram(fr[:,:,0], bins)
    hVerde,bVerde = np.histogram(fr[:,:,1], bins)
    hRojo,bRojo = np.histogram(fr[:,:,2], bins)

    # ajustamos la escala del histograma para que se vea bien en la imagen
    # además, dividimos por el máximo, para normalizar y poder comparar histogramas de imágenes
    # de diferentes tamaños
    dims = fr.shape
    xsAzul = dims[1]*bAzul[1:]/bAzul[1:].max()
    ysAzul = dims[0]-hAzul*(dims[0]/hAzul.max())

    xsVerde = dims[1]*bVerde[1:]/bVerde[1:].max()
    ysVerde = dims[0]-hVerde*(dims[0]/hVerde.max())

    xsRojo = dims[1]*bRojo[1:]/bRojo[1:].max()
    ysRojo = dims[0]-hRojo*(dims[0]/hRojo.max())

    # trasponemos el array para emparejar cada x e y, devolvemos los resultados
    return np.array([xsAzul,ysAzul]).T.astype(int), np.array([xsVerde,ysVerde]).T.astype(int), np.array([xsRojo,ysRojo]).T.astype(int)

#Función que compara dos histogramas
#Toma el máximo entre las medias de las diferencias absolutas
def compareHist(h1, h2):
    dif = [np.sum(abs(h1[i]-h2[i]))/bins for i in [0, 1, 2]]
    return max(dif)

#Aquí guardaremos las tres imágenes para comparar
imgsOrig = deque(maxlen=3)
imgs = deque(maxlen=3)
hists = deque(maxlen=3)

#Creamos un ROI
cv.namedWindow("input")
region = ROI("input")

for key, frame in autoStream():

    if region.roi:
        [x1,y1,x2,y2] = region.roi
        trozo = frame[y1:y2+1, x1:x2+1, :].copy()

        #Si pulsamos la v se guarda la imagen para ser uno de los comparadores
        if key == ord('v'):
            #Resizeamos las imágenes para poder stackearlas luego
            resized = cv.resize(trozo, (200,200))
            #Guardo la imagen sin modificar, porque quiero mostrar luego el valor de la diferencia de cada una
            imgsOrig.append(resized.copy())
            #Sacamos los histogramas, al hacerlo del resizeado puede ser ligeramente distinto, per
            #para hacerlo de otra forma o se complica mucho o puede no quedar bien al mostrar
            xysAzul, xysVerde, xysRojo = histogramas(trozo)
            #Guardo la imagen
            imgs.append(resized)
            #Guardo los histogramas para poder compararlos
            hists.append([xysAzul, xysVerde, xysRojo])

        #Si pulsamos la x reiniciamos todo
        if key == ord('x'):
            if imgs:
                cv.destroyWindow("comparadores")
                cv.destroyWindow("Resultado")
            region.roi = []
            imgs = deque(maxlen=3)
            hists = deque(maxlen=3)
            
        xysAzul, xysVerde, xysRojo = histogramas(trozo)

        cv.polylines(frame[y1:y2+1, x1:x2+1, :], [xysAzul], isClosed=False, color=(255,0,0), thickness=2)
        cv.polylines(frame[y1:y2+1, x1:x2+1, :], [xysVerde], isClosed=False, color=(0,255,0), thickness=2)
        cv.polylines(frame[y1:y2+1, x1:x2+1, :], [xysRojo], isClosed=False, color=(0,0,255), thickness=2)

        #Para cada histograma
        difs = []
        i = 0
        for hist in hists:
            #Comparamos los histogramas de referencia con el actual
            dif = compareHist([xysAzul, xysVerde, xysRojo], hist)
            difs.append(dif)
            imgs[i]=imgsOrig[i].copy()
            #Mostramos la diferencia
            putText(imgs[i], f'{dif}', orig=(90,190))
            i+=1
        
        if len(difs) == 1:
            cv.imshow("Resultado", imgsOrig[0])
        elif len(difs) == 2:
            if difs[0]<=difs[1]:
                cv.imshow("Resultado", imgsOrig[0])
            else:
                cv.imshow("Resultado", imgsOrig[1])
        elif len(difs) == 3:
            if difs[0]<=difs[1] and difs[0]<=difs[2]:
                cv.imshow("Resultado", imgsOrig[0])
            elif difs[1]<=difs[2]:
                cv.imshow("Resultado", imgsOrig[1])
            else: 
                cv.imshow("Resultado", imgsOrig[2])

        if imgs:
            frameN = np.hstack(imgs)     
            cv.imshow("comparadores", frameN)


        #Ponemos el rectángulo, con el tamaño 
        cv.rectangle(frame, (x1,y1), (x2,y2), color=(0,255,255), thickness=2)
        putText(frame, f'{x2-x1+1}x{y2-y1+1}', orig=(x1,y1-8))
    cv.imshow('input',frame)
            

cv.destroyAllWindows()