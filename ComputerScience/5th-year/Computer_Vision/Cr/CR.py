import numpy as np
import cv2   as cv

import matplotlib.pyplot as plt
import numpy.linalg      as la
import math

from ipywidgets          import interactive

img = cv.imread("cehegin.png")

def dist(x,y):
    return math.sqrt((x[0]-y[0])**2+(x[1]-y[1])**2)

def mod(x):
    return math.sqrt(x[0]*x[0]+x[1]*x[1])

Ap = (548,27)
Bp = (569,59)
Cp = (590,88)
Dp = (608,114)

#comprobamos el CR a secas
a = dist(Ap,Bp)
b = dist(Bp,Cp)
c = dist(Cp,Dp)

CR = a/(a+b)*c/(c+b)

#ahora calculamos los nuevos puntos
d = (b*c+c*c)/(3*b-c)
vCD = (Dp[0]-Cp[0], Dp[1]-Cp[1])
m = mod(vCD)
vCD = (vCD[0]/m ,vCD[1]/m)

P1 = (int(Dp[0]+d*vCD[0]), int(Dp[1]+d*vCD[1]))

b = dist(Cp,Dp)
c = dist(Dp,P1)

d = (b*c+c*c)/(3*b-c)
P2 = (int(P1[0]+d*vCD[0]), int(P1[1]+d*vCD[1]))

b = dist(Dp, P1)
c = dist(P1, P2)

d = (b*c+c*c)/(3*b-c)
P3 = (int(P2[0]+d*vCD[0]), int(P2[1]+d*vCD[1]))

q0=Bp
q1=Cp
q2=Dp
for i in range(50000):
    if d<1:
        print(i)
        print(str(b))
        print(str(c))
        break
    b = dist(q0,q1)
    c = dist(q1,q2)
    d = (b*c+c*c)/(3*b-c)
    
    q0 = q1
    q1 = q2
    q2 = (q2[0]+d*vCD[0], q2[1]+d*vCD[1])
F = (int(q2[0]),int(q2[1]))
    
cv.circle(img, Ap, 6, (0,0,255))
cv.circle(img, Bp, 6, (0,0,255))
cv.circle(img, Cp, 6, (0,0,255))
cv.circle(img, Dp, 6, (0,0,255))
cv.circle(img, P1, 6, (0,0,255))
cv.circle(img, P2, 6, (0,0,255))
cv.circle(img, P3, 6, (0,0,255))
cv.circle(img, F, 6, (0,0,255),-1)

cv.line(img, Ap, Bp, (0,0,255), 2)
cv.line(img, Bp, Cp, (0,255,0), 2)
cv.line(img, Cp, Dp, (255,0,0), 2)

cv.putText(img, "a", (555, 35), cv.FONT_HERSHEY_SIMPLEX, 1, (0,0,255))
cv.putText(img, "b", (577, 68), cv.FONT_HERSHEY_SIMPLEX, 1, (0,255,0))
cv.putText(img, "c", (598, 100), cv.FONT_HERSHEY_SIMPLEX, 1, (255,0,0))

cv.putText(img, "CR="+str(CR), (500,130), cv.FONT_HERSHEY_SIMPLEX, 0.5, (255,255,255))

while True:
    key = cv.waitKey(1) & 0xFF
    if key == 27: break
    cv.imshow("img", img)
