import ImagenesSVG

cuatroImg :: Imagen -> Imagen 
cuatroImg img = (img `junto_a` (invierte_color (giraV img))) `encima` ((invierte_color (giraV img)) `junto_a` img)

fila :: Integer -> Imagen 
fila m 
    | m==1 = blanco 
    | otherwise = if (m `mod` 2 == 0) then fila (m-1) `junto_a` negro else fila (m-1) `junto_a` blanco

ajedrez :: Integer -> Integer -> Imagen
ajedrez n m 
    | n == 1 = fila m
    | otherwise = if (n `mod` 2 == 0) then (ajedrez (n-1) m) `encima` (invierte_color (fila m)) else (ajedrez (n-1) m) `encima` (fila m)

filaImg :: Integer -> Integer -> Imagen -> Imagen 
filaImg n m img
    | n==1 = img
    | n==m = (filaImg (n-1) m img) `junto_a` (invierte_color (giraV img))
    | otherwise = (filaImg (n-1) m img) `junto_a` (if(n `mod` 2 == 0) then negro else blanco)

columna :: Integer -> Imagen
columna n 
    | n==1 = blanco 
    | otherwise = if (n `mod` 2 == 0) then columna (n-1) `encima` negro else columna (n-1) `encima` blanco

ajedrezImg :: Integer -> Imagen -> Imagen 
ajedrezImg n img
    | n==1 = filaImg 1 1 img
    | n==2 = filaImg 2 2 img `encima` giraV(invierte_color(filaImg 2 2 img))
    | otherwise = (filaImg n n img) `encima` ((if(n `mod` 2 == 0) then invierte_color(columna (n-2)) else columna(n-2)) `junto_a` (ajedrezImg (n-2) img) `junto_a` (if(n `mod` 2 == 0) then columna (n-2) else invierte_color(columna(n-2)))) `encima` (giraV(invierte_color(filaImg n n img)))