{-# OPTIONS_GHC -fno-warn-tabs #-}

type Persona = String
type Libro = String 
type BD = [(Persona, Libro)]

libros :: BD -> Persona -> [Libro]
libros bd p = [l | (x,l) <- bd, x==p]

lectores :: BD -> Libro -> [Persona]
lectores bd l = [p | (p,y) <- bd, y==l]

prestado :: BD -> Libro -> Bool 
prestado bd = not.null.(lectores bd)

numPrestados :: BD -> Persona -> Int
numPrestados bd p = length (libros bd p)

realizarPrestamo :: BD -> Persona -> Libro -> BD 
realizarPrestamo bd p l = bd ++ [(p,l)]

devolverPrestamo :: BD -> Persona -> Libro -> BD 
devolverPrestamo bd p l = [(x,y) | (x,y) <- bd, (x,y) /= (p,l)] 

type NumEjem = [(Libro, Integer)]

catalogadoLibro :: NumEjem -> Libro -> Bool
catalogadoLibro ne l = not ( null ( [(x,y) | (x,y) <- ne, x==l]))

disponibleLibro :: NumEjem -> Libro -> Bool 
disponibleLibro ne l = not ( null ( [(x,y) | (x,y) <- ne, x==l, y>0] )) 

nuevoEjemplar :: NumEjem -> Libro -> NumEjem
nuevoEjemplar ne l = if (disponibleLibro ne l) then [(x, if (x==l) then (y+1) else y) | (x,y) <- ne] else ne ++ [(l,1)]

devuelveEjemplar :: NumEjem -> Libro -> NumEjem
devuelveEjemplar ne l = [(x, if (x==l) then (y+1) else y) | (x,y) <- ne]

extraeEjemplar :: NumEjem -> Libro -> NumEjem
extraeEjemplar ne l = if (disponibleLibro ne l) then [(x,if (x==l) then y-1 else y) | (x,y) <- ne] else ne 

realizarPrestamo2 :: BD -> NumEjem -> Persona -> Libro -> (BD, NumEjem)
realizarPrestamo2 bd ne p l = if (disponibleLibro ne l) then (realizarPrestamo bd p l, extraeEjemplar ne l) else (bd, ne)

myBD = [("Juan", "L01"), ("Juan", "L02"), ("Pedro", "L01"), ("Pedro", "L02"), ("María", "L03")]
myNE = [("L01", 5), ("L02", 3), ("L03", 5), ("L04",1)]