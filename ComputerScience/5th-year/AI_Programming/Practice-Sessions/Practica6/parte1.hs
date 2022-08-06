data ArbolB a = Hoja
    | Rama (ArbolB a) a (ArbolB a)
    deriving Show

sol = Rama (Rama (Rama (Hoja) 2 (Hoja)) 5 (Rama (Hoja) 6 (Hoja))) 9 (Rama (Rama (Rama Hoja 10 Hoja) 11 (Rama Hoja 16 Hoja)) 25 (Rama (Rama (Rama Hoja 40 Hoja) 70 (Rama Hoja 60 Hoja)) 80 (Hoja)))

tama :: Ord a => ArbolB a-> Int
tama Hoja = 0
tama (Rama (i) c (d)) = 1 + (tama i) + (tama d)

aplanar :: Ord a => ArbolB a -> [a]
aplanar Hoja = []
aplanar (Rama (i) c (d)) = (aplanar i) ++ [c] ++ (aplanar d)

pertenece :: Ord a => a -> ArbolB a -> Bool
pertenece e Hoja = False
pertenece e (Rama (i) c (d)) = if (e == c) then True else ((pertenece e i) || (pertenece e d))

insertar :: Ord a => a -> ArbolB a -> ArbolB a
insertar e Hoja = Rama Hoja e Hoja 
insertar e (Rama i c d) = if (e<=c) then (Rama (insertar e i) c d) else (Rama i c (insertar e d))

extraer :: Ord a => ArbolB a -> a 
extraer Hoja = error "Esto es una hoja" 
extraer (Rama i c d) = c

maximo :: Ord a => ArbolB a -> a
maximo Hoja = error "Esto es una hoja"
maximo (Rama i c Hoja) = c
maximo (Rama i c d) = maximo d 

minimo :: Ord a => ArbolB a -> a
minimo Hoja = error "Esto es una hoja"
minimo (Rama Hoja c d) = c 
minimo (Rama i c d) = minimo i

borrar :: Ord a => a -> ArbolB a -> ArbolB a
borrar e Hoja = Hoja
borrar e (Rama Hoja c Hoja) = if (e==c) then Hoja else (Rama Hoja c Hoja)
borrar e (Rama Hoja c d) = if (e==c) then (Rama Hoja dch (borrar dch d)) else if (e<c) then (Rama Hoja c d) else (Rama Hoja c (borrar e d)) 
    where dch = minimo d
borrar e (Rama i c Hoja) = if (e==c) then (Rama (borrar izq i) izq Hoja) else if (e>c) then (Rama i c Hoja) else (Rama (borrar e i) c Hoja)
    where izq = maximo i 
borrar e (Rama i c d) = if (e==c) then (Rama (borrar izq i) izq d) else if (e<c) then (Rama (borrar e i) c d) else (Rama i c (borrar e d)) 
    where izq = maximo i 
          dch = minimo d

crearArbolL :: Ord a => [a] -> ArbolB a
crearArbolL [] = Hoja 
crearArbolL [x] = Rama Hoja x Hoja
crearArbolL (x:cola) = insertar x (crearArbolL cola)
    
ordenarConArbol :: Ord a => [a] -> [a]
ordenarConArbol l = aplanar (crearArbolL l)

-- Conjuntos con listas
perteneceC :: Eq a => a -> [a] -> Bool 
perteneceC x [] = False 
perteneceC x (y:cola) = (x==y) || (perteneceC x cola)

subconjunto :: Eq a => [a] -> [a] -> Bool 
subconjunto [] l = True
subconjunto l [] = False 
subconjunto (x:cola) l = (perteneceC x l) && (subconjunto cola l)

igualesC :: Eq a => [a] -> [a] -> Bool
iguales l1 l2 = (subconjunto l1 l2) && (subconjunto l2 l1)