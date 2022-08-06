import Rosadelfa

type Valor =(Integer, Integer)

type Adelfa = RAdelfa Valor

divisores :: Integer -> [Integer]
divisores n = [k | k <- [1..n], (mod n k) == 0]

primo :: Integer -> Bool 
primo 1 = False 
primo n = divisores n == [1,n]

primos :: Integer -> [Integer]
primos n = [p | p <- [2..n], primo p]

exponente :: Integer -> Integer -> Integer 
exponente j n = if(n==j) then 1 else if not(mod n j == 0) then 0 else (1 + exponente j (div n j))

factorizacion :: Integer -> [Integer]
factorizacion 0 = [0]
factorizacion 1 = [1]
factorizacion n = [if(mod n j == 0) then exponente j n else 0 | j <- primos n]

--godel :: Integer -> Integer 
--godel n = 