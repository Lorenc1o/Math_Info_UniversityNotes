from cv2 import findHomography
import numpy as np
import cv2   as cv
from umucv.stream import autoStream
import matplotlib.pyplot as plt
import numpy.linalg      as la
from umucv.util import Help
from ipywidgets          import interactive
from copy import deepcopy
import torch
from classifier import load_model
# https://medium.com/mlearning-ai/augmented-reality-sudoku-solver-part-ii-cdfc035a415c
# cargamos el modelo de detección de caracteres
model_file = 'char74k-cnn.pth'

def rgb2gray(x):
    return cv.cvtColor(x,cv.COLOR_RGB2GRAY)

M = 9

#Chekea si un número puede estar en una casilla concreta del sudoku
def solucion(grid, row, col, num):
    for x in range(9):
        if grid[row][x] == num:
            return False
             
    for x in range(9):
        if grid[x][col] == num:
            return False
 
    startRow = row - row % 3
    startCol = col - col % 3
    for i in range(3):
        for j in range(3):
            if grid[i + startRow][j + startCol] == num:
                return False
    return True
 

# https://stackoverflow.com/questions/46274961/removing-horizontal-lines-in-image-opencv-python-matplotlib

#Función para eliminar las líneas del tablerp
def quitarLineas(warped):
    #Pasamos a escala de grises
    g = cv.cvtColor(warped, cv.COLOR_BGR2GRAY)
    thresh = cv.threshold(g, 0, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)[1]

    #Quitamos las líneas horizontales
    horizontal_kernel = cv.getStructuringElement(cv.MORPH_RECT, (25,1))
    hor_lines = cv.morphologyEx(thresh, cv.MORPH_OPEN, horizontal_kernel, iterations=2)

    cnts = cv.findContours(hor_lines, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
    cnts = cnts[0] if len(cnts)==2 else cnts[1]
    for c in cnts:
        cv.drawContours(warped, [c], -1, (255, 255, 255), 4)

    #Quitamos las líneas verticales
    vertical_kernel = cv.getStructuringElement(cv.MORPH_RECT, (1,25))
    ver_lines = cv.morphologyEx(thresh, cv.MORPH_OPEN, vertical_kernel, iterations=2)

    cnts = cv.findContours(ver_lines, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
    cnts = cnts[0] if len(cnts)==2 else cnts[1]
    for c in cnts:
        cv.drawContours(warped, [c], -1, (255, 255, 255), 4)

    cv.imwrite("warped.png", warped) #Para comprobar
    return warped


# https://stackoverflow.com/questions/38654302/how-can-i-sort-contours-from-left-to-right-and-top-to-bottom

#Función para ordenar las casillas del sudoku de izquierda a derecha y de arriba a abajo
# Primero se ordena de izquierda a derecha
# Después de arriba a abajo
# Por último, cada fila se ordena de izquierda a derecha, porque puede ser que al ordenar de arriba a abajo
#   se desordenen.
# Para eso sirve el parámetro only_X. Nótese que esto último no lo hace la función, tenemos que pasarle cada
#   fila nosotros.
def sort_contours(contours, x_axis_sort='LEFT_TO_RIGHT', y_axis_sort='TOP_TO_BOTTOM', only_X = False):
    # initialize the reverse flag
    x_reverse = False
    y_reverse = False
    if x_axis_sort == 'RIGHT_TO_LEFT':
        x_reverse = True
    if y_axis_sort == 'BOTTOM_TO_TOP':
        y_reverse = True
    
    boundingBoxes = [cv.boundingRect(c) for c in contours]

    #sorting on x-axis 
    contours, boundingBoxes = zip(*sorted(zip(contours, boundingBoxes),
    key=lambda b:b[1][0], reverse=x_reverse))
    
    if not only_X:
        # sorting on y-axis 
        (contours, boundingBoxes) = zip(*sorted(zip(contours, boundingBoxes),
        key=lambda b:b[1][1], reverse=y_reverse))

    # return the list of sorted contours and bounding boxes
    return (contours, boundingBoxes)

# https://stackoverflow.com/questions/55169645/square-detection-in-image

#Función para obtener las casillas del tablero una vez hemos quitado las líneas negras
def sacarCasillas(warped, tam):
    g = cv.cvtColor(warped, cv.COLOR_BGR2GRAY)
    blur = cv.medianBlur(g, 5)
    sharpen_kernel = np.array([[-1,-1,-1],[-1,9,-1],[-1,-1,-1]])
    sharpen = cv.filter2D(blur, -1, sharpen_kernel)

    thresh = cv.threshold(sharpen, 160, 255, cv.THRESH_BINARY_INV)[1]
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (3,3))
    close = cv.morphologyEx(thresh, cv.MORPH_CLOSE, kernel, iterations=2)

    #Aquí sacamos las casillas
    cnts = cv.findContours(close, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
    cnts = cnts[0] if len(cnts)==2 else cnts[1]

    #Aquí las ordenamos
    cnts,_ = sort_contours(cnts)

    cnts = np.asarray(cnts, dtype=object)

    #Nótese que una casilla tiene área ~area/81
    min_area = tam/150
    max_area = tam/10

    #Nos quitamos posibles contornos problemáticos
    cnts = [c for c in cnts if min_area<cv.contourArea(c)<max_area]
    #Aquí ordenamos por filas
    for i in range(9):
        cnts[i*9:(i+1)*9],_ = sort_contours(cnts[i*9:(i+1)*9], only_X=True)

    fila = 0
    col = 0
    
    casillas = []
    boxes = []

    #Aquí guardamos las casillas para devolverlas por separado
    for c in cnts:
        area = cv.contourArea(c)
        if min_area < area < max_area:
            x,y,w,h = cv.boundingRect(c)
            casilla = warped[y:y+h, x:x+w]
            casillas.append(casilla.copy())
            boxes.append([x,y,w,h])
            cv.rectangle(warped, (x,y), (x+w,y+h), (36,255,12), 2)
            cv.putText(warped,"("+str(fila)+","+str(col)+")",(x+w//4,y+h//2), cv.FONT_HERSHEY_COMPLEX, 0.4, (36,255,12))
            
            if col<8:
                col += 1
            else:
                fila+=1
                col=0
        if area > max_area:
            print("mal")
    return warped, casillas, boxes

#Función para poner los números en las casillas
def ponerNums(warped, grid, boxes, solucioname):
    fila = col = 0

    for b in boxes:
        x,y,w,h = b

        if grid[fila,col] == 0:
            return warped
        
        if (grid[fila, col]!=0 and solucioname[fila,col]):
            cv.putText(warped, str(grid[fila,col]), (x+w//4,y+h//2), cv.FONT_HERSHEY_SIMPLEX, 1, (255,255,12), 2)

        if col<8:
            col += 1
        else:
            fila+=1
            col=0
    return warped

#Este método sirve para aclarar los bordes de una casilla y ver si tiene algún dígito dentro
def procesarCasilla(c):
    c = rgb2gray(c)
    #Primero expandimos la imagen
    c = cv.resize(c, (112,112), interpolation=cv.INTER_CUBIC)

    #Y le aplicamos un filtro de bluring para aumentar las diferencias entre píxeles
    c = cv.GaussianBlur(c, (5,5), 0)
    #así como un threshold
    c = cv.threshold(c, 110, 255, cv.THRESH_TRUNC)[1]
    # todos los píxeles mayor que 110 los ponemos al máximo
    media = np.mean(c)
    c[c >= media] = 255
    c[c < media] = 0

    #Reescalamos la imagen
    c = cv.resize(c, (28,28), interpolation=cv.INTER_CUBIC)

    #Si hay menos de 30 píxeles negros (número obtenido por prueba/error), asumimos que no hay ningún dígito en la casilla

    if np.sum(c==0)<30:
        return None, np.sum(c==0)

    return c, np.sum(c==0)

#El solver rápido comienza aquí
#Obtenido de https://onestepcode.com/sudoku-solver-python-2/

#Obtiene las zonas de 9x9
def get_subgrids(grid: np.ndarray) -> np.ndarray:
    """Divide the input grid into 9 3x3 sub-grids"""

    subgrids = []
    for box_i in range(3):
        for box_j in range(3):
            subgrid = []
            for i in range(3):
                for j in range(3):
                    subgrid.append(grid[3*box_i + i][3*box_j + j])
            subgrids.append(subgrid)
    return np.array(subgrids)

#Obtiene los posibles números de cada celda del sudoku
def get_candidates(grid : np.ndarray) -> list:
    """Get a list of candidates for each cell of the input grid"""

    def subgrid_index(i : int, j : int) -> int:
        return (i//3) * 3 + j // 3

    subgrids = get_subgrids(grid)
    grid_candidates = []
    for i in range(9):
        row_candidates = []
        for j in range(9):
            # Row, column and subgrid digits
            row = set(grid[i])
            col = set(grid[:, j])
            sub = set(subgrids[subgrid_index(i, j)])
            common = row | col | sub
            candidates = set(range(10)) - common
            # If the case is filled take its value as the only candidate
            if not grid[i][j]:
                row_candidates.append(list(candidates))
            else:
                row_candidates.append([grid[i][j]])
        grid_candidates.append(row_candidates)
    return grid_candidates

#Cuando rellenamos una casilla, reducimos la cantidad
#de candidatos, comparando los candidatos filtrados
#con la normal, y quedándonos con la más corta
def merge(candidates_1, candidates_2):
    candidates_min = []
    for i in range(9):
        row = []
        for j in range(9):
            if len(candidates_1[i][j]) < len(candidates_2[i][j]):
                row.append(candidates_1[i][j][:])
            else:
                row.append(candidates_2[i][j][:])
        candidates_min.append(row)
    return candidates_min

#Si una casilla solo tiene un posible candidato, lo ponemos
def fill_singles(grid, candidates=None):
    grid = grid.copy()
    if not candidates:
        candidates = get_candidates(grid)
    any_fill = True
    while any_fill:
        any_fill = False
        for i in range(9):
            for j in range(9):
                if len(candidates[i][j]) == 1 and grid[i][j] == 0:
                    grid[i][j] = candidates[i][j][0]
                    candidates = merge(get_candidates(grid),
                                       candidates)
                    any_fill = True
    return grid

#Vamos seleccionando las casillas con menos candidatos, para ir
#probando
def make_guess(grid, candidates=None):
    grid = grid.copy()
    if not candidates:
        candidates = get_candidates(grid)
    # Getting the shortest number of candidates > 1:
    min_len = sorted(list(set(map(
       len, np.array(candidates).reshape(1,81)[0]))))[1]
    for i in range(9):
        for j in range(9):
            if len(candidates[i][j]) == min_len:
                for guess in candidates[i][j]:
                    grid[i][j] = guess
                    solution = filtered_solve(grid)
                    if solution is not None:
                        return solution
                    # Discarding a wrong guess
                    grid[i][j] = 0

#Verifica que tenemos una combinación válida
def is_valid_grid(grid):
    candidates = get_candidates(grid)
    for i in range(9):
        for j in range(9):
            if len(candidates[i][j]) == 0:
                return False
    return True

#Verifica que el sudoku está terminado
def is_solution(grid):
    if np.all(np.sum(grid, axis=1) == 45) and \
       np.all(np.sum(grid, axis=0) == 45) and \
       np.all(np.sum(get_subgrids(grid), axis=1) == 45):
        return True
    return False

#Se verifican los candidatos actuales para ver si dan lugar
#a combinaciones válidas
def filter_candidates(grid):
    test_grid = grid.copy()
    candidates = get_candidates(grid)
    filtered_candidates = deepcopy(candidates)
    for i in range(9):
        for j in range(9):
            # Check for empty cells
            if grid[i][j] == 0:
                for candidate in candidates[i][j]:
                    # Use test candidate
                    test_grid[i][j] = candidate
                    # Remove candidate if it produces an invalid grid
                    if not is_valid_grid(fill_singles(test_grid)):
                        filtered_candidates[i][j].remove(candidate)
                    # Revert changes
                    test_grid[i][j] = 0
    return filtered_candidates

def filtered_solve(grid):
    candidates = filter_candidates(grid)
    grid = fill_singles(grid, candidates)
    if is_solution(grid):
        return grid
    if not is_valid_grid(grid):
        return None
    return make_guess(grid, candidates)

# Barra de comandos
help = Help(
"""
HELP

a: Solve the puzzle showing all steps using a backtracking approach. Takes very long.
b: Solve the puzzle and show only the solution. Run faster.

""")

#Variable de estado
solve = 0
mode = 0

# Inicializamos el grid del sudoku, a todo 0
grid = np.zeros([M,M], dtype=np.int32)

# Aquí meteremos las casillas procesadas, para visualización y debug
gridFrame = np.ones([28*9,28*9], dtype=np.uint8)*255

# Aquí guardamos las casillas que debemos solucionar
solucioname = []

#Aquí creamos una matriz que generará los valores del algoritmo por fuerza bruta
fb = np.zeros([9,9],dtype=np.uint8)

indiceFB = 0

for key, frame in autoStream():
    if key == 27:      
        break

    if key == ord('a'):
        if solve==0:
            print("A resolver!")
            solve = 1
    if key == ord('b'):
        if solve==0:
            print("A resolver!")
            solve = 1
            mode = 1

    g = rgb2gray(frame)

    if solve==1:
        solve = 2
        # Aplicamos un filtro de blurring, esto parece ser que facilita la detección de 
        # los contours
        blur = cv.GaussianBlur(g, (5,5), 0)
        thresh = cv.adaptiveThreshold(blur, 255, cv.ADAPTIVE_THRESH_GAUSSIAN_C, cv.THRESH_BINARY_INV, 11, 2)
        
        # Sacamos los contornos y nos quedamos con el que presenta mayor área
        # o sea, el que se corresponde al tablero completo.
        conts = cv.findContours(thresh, cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)[0]

        mayor = max(conts, key=cv.contourArea)

        # Creamos una máscara tal que el interior del tablero es blanco, y el exterior negro
        mask = np.zeros(g.shape, np.uint8)
        cv.drawContours(mask, [mayor], 0, 255, -1)
        cv.drawContours(mask, [mayor], 0, 0, 2)

        # Ahora creamos una máscara blanca y le asignamos en la zona del tablero
        # la información original (en escala de grises)
        tab = 255 * np.ones_like(g)
        tab[mask == 255] = g[mask == 255]

        # Calculamos el perímetro del contorno
        per = cv.arcLength(mayor, True)

        # Aproximamos las curvas para detectar los vértices
        aprox = cv.approxPolyDP(mayor, 0.015 * per, True)
        vertex = np.squeeze(aprox)

        #sacamos la anchura y la altura
        gridW = np.max(vertex[:,0])-np.min(vertex[:,0])
        gridH = np.max(vertex[:,1])-np.min(vertex[:,1])
        tam = gridW*gridH

        # Ahora vamos a aproximar las coordenadas del grid
        # para poder obtener la homografía que lo aplana

        sumV = vertex.sum(axis=1)
        diffV = np.diff(vertex, axis=1)
        bnd = np.array([
            vertex[np.argmin(sumV)],
            vertex[np.argmin(diffV)],
            vertex[np.argmax(sumV)],
            vertex[np.argmax(diffV)]
        ], dtype = np.float32)

        mask = np.zeros((frame.shape[0],frame.shape[1]))
        cv.fillConvexPoly(mask, vertex, 1)
        mask = mask.astype(bool)

        dst = np.array([
            [0,0],
            [gridW-1,0],
            [gridW-1, gridH-1],
            [0, gridH-1]
        ], dtype = np.float32)

        #Aquí ya sacamos la homografía y el tablero rectificado
        H,_ = findHomography(bnd, dst)
        H2,_ = findHomography(dst,bnd)
        warped_frame = cv.warpPerspective(frame, H, (gridW, gridH))
        BordeH = int(gridH*0.01)
        BordeW = int(gridW*0.01)
        print(H2)

        #Nos quedamos solo con el tablero, quitando el borde exterior en la medida de lo posible
        #warped_frame = warped_frame[BordeH:-BordeH, BordeW:-BordeW]
        warped_orig = warped_frame.copy()

        #Eliminamos las líneas del tablero
        warped_frame = quitarLineas(warped_frame)

        #Obtenemos las casillas del tablero
        warped2,casillas,boxes = sacarCasillas(warped_frame.copy(), tam)
        print(len(casillas))

        # Cargamos el modelo para detectar los dígitos
        model = load_model(model_file)
        model.eval()

        # Iteramos las filas
        for i in range(M):

            #Iteramos las columnas
            for j in range(M):

                #Copiamos la casilla
                casilla = casillas[9*i+j].copy()
                #Procesamos la casilla y si no tiene un dígito, lo ponemos a 0
                # y seguimos con la siguiente

                casilla,_ = procesarCasilla(casilla)

                if casilla is None:
                    grid[i,j] = 0
                    continue
                gridFrame[28*i:28*(i+1),28*j:28*(j+1)] = casilla.copy()
                casilla = casilla/255
                casilla = np.array(casilla).reshape((1,1,28,28))

                #Convertimos la imagen a tensor para poder usar el modelo
                casillaT = torch.tensor(casilla, dtype = torch.float)

                #Usamos el modelo para sacar el dígito
                casillaPred = np.array(model(casillaT).detach(), dtype=np.float32).flatten()

                #El dígito es aquel con el valor máximo entre las predicciones
                digito = int(np.argmax(casillaPred))

                #Ahora vamos a comprobar que este número aún no está ni en esta fila, ni en esta columna
                #ni en esta zona, ya que esto no debe ocurrir

                #Sacamos la zona
                MZona = 3
                fZona = i - (i % 3)
                cZona = j - (j % 3)
                # Y sus valores
                zona = grid[fZona:fZona+3,cZona:cZona+3]
                print("-------------------------------------------")
                print(zona)
                print("+++++++++++++++++++++++++++++++++++++++++++")
                print("i="+str(i)+", j="+str(j)+" -> "+str(digito))
                print("puntuación: " + str(casillaPred[digito]))
                if digito in grid[i,:]:
                    x = i
                    y = list(grid[i,:]).index(digito)
                    print("coincidencia en fila: x="+str(x)+", y="+str(y))
                elif digito in grid[:,j]:
                    x = list(grid[:,j]).index(digito)
                    y = j
                    print("coincidencia en columna: x="+str(x)+", y="+str(y))
                elif digito in zona:
                    pos = list(zona.flatten()).index(digito)
                    x = fZona + pos // 3
                    y = cZona + pos % 3
                    print("coincidencia en zona: x="+str(x)+", y="+str(y))
                else:
                    #Si no está repetido
                    #Ponemos el dígito en la posición
                    grid[i,j] = digito
                    print("Sin coincidencia")
                    continue

                #Si está repetido, cogemos la imagen de la casilla replicada
                rep = casillas[9*i+j].copy()

                #Procesamos la casilla repetida
                rep,_ = procesarCasilla(rep)

                #Si está vacía, ponemos el dígito en la actual
                # y la supuestamente repetida a 0
                if rep is None:
                    grid[i,j] = digito
                    grid[x,y] = 0
                    continue
                #Si no
                rep = rep/255
                rep = np.array(rep).reshape((1,1,28,28))
                repT = torch.tensor(rep, dtype=torch.float)
                repPred = np.array(model(repT).detach(), dtype=np.float32).flatten()

                #Si la precisión de la predicción actual es mayor
                if casillaPred[digito] > repPred[digito]:
                    #Ponemos el dígito en la casilla actual
                    grid[i,j]=digito
                    #Le asignamos -inf a la puntuación en la repetida
                    repPred[digito] = np.NINF
                    #Cogemos en la repetida el siguiente dígito en cuanto a puntuación
                    grid[x,y] = int(np.argmax(repPred))
                else: #Si la precisión es mayor para la repetida
                    grid[x,y] = digito
                    casillaPred[digito] = np.NINF
                    grid[i,j] = int(np.argmax(casillaPred))
        print(grid)
        solucioname = grid==0

    #Esto es que ya hemos procesado el tablero, y pasamos a resolverlo
    elif solve==2:
        if mode==0:
            #Lo vamos a hacer por fuerza bruta
            #Cada vez generamos una posible solución
            grid[solucioname] = fb[solucioname]
            #Si son de los fijos, los saltamos
            while not solucioname[indiceFB//9,indiceFB%9]:
                indiceFB += 1
            fb[indiceFB//9,indiceFB%9] = (fb[indiceFB//9,indiceFB%9]+1)%10
            if fb[indiceFB//9,indiceFB%9] == 0:
                indiceFB -= 1
                #Si los anteriores son de los fijos, lo saltamos
                while not solucioname[indiceFB//9,indiceFB%9]:
                    indiceFB -= 1
            else:
                if solucion(grid, indiceFB//9, indiceFB%9, fb[indiceFB//9,indiceFB%9]):
                    indiceFB += 1
            warped_frame = ponerNums(warped_orig.copy(),grid,boxes,solucioname)
            fin = cv.warpPerspective(warped_frame, H2, (frame.shape[1],frame.shape[0]))

            frame[mask] = fin[mask]
        
            isSolved = True
            if indiceFB < 81:
                isSolved = False
        
        elif mode==1:
            grid = filtered_solve(grid)
            warped_frame = ponerNums(warped_orig.copy(),grid,boxes,solucioname)
            fin = cv.warpPerspective(warped_frame, H2, (frame.shape[1],frame.shape[0]))

        if isSolved:
            solve += 1
    if solve>0:
        cv.imshow("warped2", warped2)
        cv.imshow("prueba", cv.cvtColor(gridFrame, cv.COLOR_GRAY2BGR))
        cv.imshow("warped", warped_frame)
    if solve == 3:
        frame[mask] = fin[mask]
    cv.imshow("sudoku", frame)
cv.destroyAllWindows()