--Para tener siempre activados patrones n+k
{-# LANGUAGE NPlusKPatterns #-}

--Para evitar que aparezcan los warnings debidos a tabuladores
{-# OPTIONS_GHC -fno-warn-tabs #-} 

--1.
maximo :: Integer -> Integer -> Integer
maximo n m = if(n>=m) then n else m

maximoC :: Integer -> (Integer -> Integer)
maximoC n m = if(n>=m) then n else m

--2.
area :: Double -> Double
area r = r*r*22/7

--3.
fib :: Integer -> Integer
fib n = if(n==0) then 0 else if (n==1) then 1 else fib (n-1) + fib (n-2) 

fib2 :: Integer -> Integer
fib2 0 = 0
fib2 1 = 1
fib2 n = fib2 (n-1) + fib2 (n-2)

--4.
absol :: Integer -> Integer
absol n = if(n>=0) then n else -n

--5. 
cuadrado :: Integer -> Integer
cuadrado n = n*n

aumentar :: Integer -> Integer
aumentar n = cuadrado (n+1)

aumentar2 :: Integer -> Integer 
aumentar2 n = cuadrado n + 1

-- segunda parte
sucesor :: Integer -> Integer 
sucesor = (+1)

aumentar' ::  Integer -> Integer
aumentar' = cuadrado.sucesor

aumentar2' :: Integer -> Integer
aumentar2' = sucesor.cuadrado

--6.
nott :: Bool -> Bool 
nott x = if(x) then False else True

nAnd :: Bool -> Bool -> Bool 
nAnd x y = if(x) then (nott y) else True

nAnd1 :: Bool -> Bool -> Bool 
nAnd1 x y = if(x && y) then False else True

--7.
xOr, xOr' :: Bool -> Bool -> Bool
xOr x y = if(x==y) then False else True 

xOr' x y = nott(x==y)

--8.
minimo :: Integer -> Integer -> Integer 
minimo x y = if(x<=y) then x else y

minimoTres :: Integer -> Integer -> Integer -> Integer
minimoTres x y z = if (x <= a ) then x else a 
    where a = minimo y z

--9.
maximoTres :: Integer -> Integer -> Integer -> Integer
maximoTres x y z
    | x >= a = x
    | otherwise = a 
    where a = maximo y z

--10.
numeroCentral :: Integer -> Integer -> Integer -> Integer 
numeroCentral x y z
    | x == a = minimo y z
    | x == b = maximo y z
    | otherwise = x
    where a = minimoTres x y z
          b = maximoTres x y z

--11.
productoRango :: Integer -> Integer -> Integer 
productoRango m n
    | n<m = 0
    | n==m = n
    | otherwise = m * productoRango (m+1) n 

factorial :: Integer -> Integer 
factorial n = productoRango 1 n

--12.
prod :: Integer -> Integer -> Integer
prod n m = if(n<=0 || m<=0) then 0 else n + prod n (m-1)