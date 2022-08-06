#!/usr/bin/env python

import numpy as np
import cv2 as cv
from umucv.util import ROI, putText
import keyboard

#Creamos un ROI
cv.namedWindow("input")
region = ROI("input")
img = cv.imread('elvis.jpg')
processed = False

while True:
    imgS = img.copy()
    k = cv.waitKey(1) & 0xFF
    if k == 27:      
        break
    
    if region.roi:
        [x1,y1,x2,y2] = region.roi

        #Si presionamos c teniendo un ROI seleccionado, se efectúa el algoritmo
        if keyboard.is_pressed('c'):
            rect = (x1,y1,x2,y2)
            #Creamos la máscara
            mask = np.zeros(img.shape[:2],np.uint8)
            bgdModel = np.zeros((1,65),np.float64)
            fgdModel = np.zeros((1,65),np.float64)
            #Efectúamos el algoritmo, indicando el rectángulo señalado y haciendo 5 iteraciones
            cv.grabCut(img,mask,rect,bgdModel,fgdModel,5,cv.GC_INIT_WITH_RECT)
            mask2 = np.where((mask==2)|(mask==0),0,1).astype('uint8')
            #Obtenemos la imagen resultado
            img2 = img*mask2[:,:,np.newaxis]
            processed = True
        cv.rectangle(imgS, (x1,y1), (x2,y2), color=(0,255,255), thickness=2)
        putText(imgS, f'{x2-x1+1}x{y2-y1+1}', orig=(x1,y1-8))

    if processed:        
        cv.imshow("resultado", img2)
    
    
    
    cv.imshow("input", imgS)