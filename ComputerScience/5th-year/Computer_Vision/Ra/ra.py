import numpy as np
import cv2   as cv
from umucv.stream import autoStream
import matplotlib.pyplot as plt
import numpy.linalg      as la
from umucv.util import Help
from ipywidgets          import interactive

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

#pasa una imagen a escala de grises
def rgb2gray(x):
    return cv.cvtColor(x,cv.COLOR_RGB2GRAY)

# ratio area/perímetro^2, normalizado para que 100 (el arg es %) = círculo
def redondez(c):
    p = cv.arcLength(c.astype(np.float32),closed=True)
    oa = orientation(c)
    if p>0:
        return oa, 100*4*np.pi*abs(oa)/p**2
    else:
        return 0,0

# area, con signo positivo si el contorno se recorre "counterclockwise"
def orientation(x):
    return cv.contourArea(x.astype(np.float32),oriented=True)

def boundingBox(c):
    (x1, y1), (x2, y2) = c.min(0), c.max(0)
    return (x1, y1), (x2, y2)

# comprobar que el contorno no se sale de la imagen
def internal(c,h,w):
    (x1, y1), (x2, y2) = boundingBox(c)
    return x1>1 and x2 < w-2 and y1 > 1 and y2 < h-2

# reducción de nodos
def redu(c,eps=0.5):
    red = cv.approxPolyDP(c,eps,True)
    return red.reshape(-1,2)

# intenta detectar polígonos de n lados
def polygons(cs,n,prec=2):
    rs = [ redu(c,prec) for c in cs ]
    return [ r for r in rs if r.shape[0] == n ]

# detecta siluetas oscuras que no sean muy pequeñas ni demasiado alargadas
def extractContours(g, minarea=10, minredon=25, reduprec=1):
    #gt = cv.adaptiveThreshold(g,255,cv.ADAPTIVE_THRESH_GAUSSIAN_C, cv.THRESH_BINARY,101,-10)
    ret, gt = cv.threshold(g,189,255,cv.THRESH_BINARY+cv.THRESH_OTSU)
    
    contours = cv.findContours(gt, cv.RETR_TREE,cv.CHAIN_APPROX_SIMPLE)[-2]

    h,w = g.shape
    
    tharea = (min(h,w)*minarea/100.)**2 
    
    def good(c):
        oa,r = redondez(c)
        black = oa > 0 # and positive orientation
        return black and abs(oa) >= tharea and r > minredon

    ok = [redu(c.reshape(-1,2),reduprec) for c in contours if good(c)]
    return [ c for c in ok if internal(c,h,w) ]

# mide el error de una transformación (p.ej. una cámara)
# rms = root mean squared error
# "reprojection error"
def rmsreproj(view, model, transf):
    err = view - htrans(transf,model)
    return np.sqrt(np.mean(err.flatten()**2))

# juntar columnas
def jc(*args):
    return np.hstack(args)

def pose(K, image, model):
    ok,rvec,tvec = cv.solvePnP(model, image, K, (0,0,0,0))
    if not ok:
        return 1e6, None
    R,_ = cv.Rodrigues(rvec)
    M = K @ jc(R,tvec)
    rms = rmsreproj(image,model,M)
    return rms, M

def rots(c):
    return [np.roll(c,k,0) for k in range(len(c))]

# probamos todas las asociaciones de puntos imagen con modelo
# y nos quedamos con la que produzca menos error
def bestPose(K,view,model):
    poses = [ pose(K, v.astype(float), model) for v in rots(view) ]
    return sorted(poses,key=lambda p: p[0])[0]

# qué hacer si detectamos clicks
def mouse_handler(event, x, y, flags, params):
    #Si detectamos un doble click, movemos el cubo a esa posición
    if event == cv.EVENT_LBUTTONDBLCLK:
        global v, H2
        if H2:
            v = htrans(H2[0], (x,y))
            v = np.array([v[0],v[1],0], dtype=np.float64)
    return

# definimos el cubo

#vértice principal del cubo
v = np.array([0,0,0], dtype=np.float64)
#lado de la base
l = 1.
#altura
h = 1.

cube = np.array([
    v,
    v+[l,0,0],
    v+[l,l,0],
    v+[0,l,0],
    v,
    
    v+[0,0,h],
    v+[l,0,h],
    v+[l,l,h],
    v+[0,l,h],
    v+[0,0,h],
        
    v+[l,0,h],
    v+[l,0,0],
    v+[l,l,0],
    v+[l,l,h],
    v+[0,l,h],
    v+[0,l,0]
    ], dtype=np.float64)
    

# Definimos el marcador
marker = np.array(
       [[0,   0,   0],
        [0,   1,   0],
        [0.5, 1,   0],
        [0.5, 0.5, 0],
        [1,   0.5, 0],
        [1,   0,   0]])

# Punto fuera del marcador
point = np.array([0.75, 0.75, 0])

# Cuadrado que recubre el marcador
cuadrado = np.array([
    [-0.1,-0.1,0],
    [1.1,-0.1,0],
    [1.1,1.1,0],
    [-0.1, 1.1, 0]
])

# matriz de cámara obtenida mediante calibración
K = np.array([[478.91384405,   0.,        320.],
             [  0.,         478.91384405, 240.],
             [  0.,          0. ,          1.        ]])

color = [0,0,0]

# Barra de comandos
help = Help(
"""
HELP

b: paint blue
r: paint red
g: paint green
k: paint black

(movements are relative to marker)
w: move up 
x: move down
d: move right
a: move left

t: increase height
y: decrease height

+: increase size
-: decrease size

o: hide marker

double click: move cube to that position

q: reset original cube
""")

hide = False

cv.namedWindow("RA")
cv.setMouseCallback("RA", mouse_handler)
pr=0
for key, frame in autoStream():
    cube = np.array([
    v,
    v+[l,0,0],
    v+[l,l,0],
    v+[0,l,0],
    v,
    
    v+[0,0,h],
    v+[l,0,h],
    v+[l,l,h],
    v+[0,l,h],
    v+[0,0,h],
        
    v+[l,0,h],
    v+[l,0,0],
    v+[l,l,0],
    v+[l,l,h],
    v+[0,l,h],
    v+[0,l,0]
    ], dtype=np.float64)

    k = cv.waitKey(1) & 0xFF
    if k == 27:      
        break
    help.show()
    # Si pulsamos '+' el cubo aumenta de tamaño
    if key == ord('+'):
        l *= 2
        h *= 2
    # Si pulsamos '-' el cubo decrementa de tamaño
    if key == ord('-'):
        l /= 2
        h /= 2
    
    # Si pulsamos 'b' el color cambia a azul
    if key == ord('b'):
        color = [255,0,0]
    # Si pulsamos 'g' el color cambia a verde
    if key == ord('g'):
        color = [0,255,0]
    # Si pulsamos 'r' el color cambia a rojo
    if key == ord('r'):
        color = [0,0,255]
    # Si pulsamos 'k' el color cambia a negro
    if key == ord('k'):
        color = [0,0,0]

    # Las direcciones son relativas al marcador!!
    # Si pulsamos la 'w', el cubo se desplaza hacia arriba
    if key == ord('w'):
        v += [0.2,0,0]
    # Si pulsamos la 'x', el cubo se desplaza hacia abajo
    if key == ord('x'):
        v -= [0.2,0,0]
    # Si pulsamos la 'a', el cubo se desplaza hacia izq
    if key == ord('a'):
        v += [0,0.2,0]
    # Si pulsamos la 'd', el cubo se desplaza hacia dcha
    if key == ord('d'):
        v -= [0,0.2,0]

    # Si pulsamos la 't', el cubo crece hacia arriba
    if key == ord('t'):
        h += 0.2
    
    #Si pulsamos la 'y', el cubo decrece
    if key == ord('y'):
        if h>0.2:
            h -= 0.2

    #Si pulsamos la 'o', ocultamos el marcador
    if key == ord('o'):
        hide = not hide

    #Si pulsamos 'q', el cubo vuelve a su forma original
    if key == ord('q'):
        v = v-v
        l = 1.
        h = 1.
        color = [0,0,0]

    g = rgb2gray(frame)

    conts = extractContours(g, reduprec=3)
    good = polygons(conts,6)

    # Para cada polígono
    for g in good:
        # Estimamos la matriz de cámara
        err, H = bestPose(K, g, marker)
        # Dibujamos el cubo

        if err<50:
            H2 = cv.findHomography(np.int32([htrans(H, marker)]),marker)
            if hide:
                ptrans = np.int32([htrans(H, point)])
                clr = frame[ptrans[0][0],ptrans[0][1]]
                b = int(clr[0])
                g = int(clr[1])
                r = int(clr[2])

                cv.fillConvexPoly(frame, np.int32([htrans(H, cuadrado)]), [b,g,r])
            cv.polylines(frame, np.int32([htrans(H, cube)]), True, color, 3)

    

    cv.imshow('RA',frame)
cv.destroyAllWindows()