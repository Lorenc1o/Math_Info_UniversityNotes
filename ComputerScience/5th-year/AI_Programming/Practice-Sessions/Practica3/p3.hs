type Racional = (Integer, Integer)

simplificaRac :: Racional -> Racional
simplificaRac (n,m) = (((signum n)*(signum m)) * (div (abs n) g), div (abs m) g) where g=gcd n m

multRac :: Racional -> Racional -> Racional 
multRac (p1,q1) (p2,q2) = simplificaRac (p1*p2, q1*q2)

divRac :: Racional -> Racional -> Racional 
divRac (p1,q1) (p2,q2) = simplificaRac (p1*q2, p2*q1)

sumRac :: Racional -> Racional -> Racional
sumRac (p1,q1) (p2,q2) = simplificaRac (p1*q2+p2*q1, q1*q2)

resRac :: Racional -> Racional -> Racional 
resRac r1 r2 = sumRac r1 (multRac (-1,1) r2)

muestraRac :: Racional -> String 
muestraRac (p1,q1)
    | q1==0 = "Indefinido"
    | mod p1 q1 == 0 = show(div p1 q1)
    | otherwise = (show p1) ++"/"++(show q1)

data Racional2 = Rac {num::Integer, den::Integer}
instance Show Racional2 where 
    show (Rac p q) = muestraRac2 (simplificaRac2 (Rac p q))

instance Num Racional2 where 
    (*) = multRac2
    (+) = sumRac2
    negate r = multRac2 (Rac (-1) 1) r
    fromInteger n = (Rac n 1)
    signum (Rac p q) = (Rac ((signum p)*(signum q)) 1)
    abs (Rac p q) = (Rac (abs p) (abs q))

simplificaRac2 :: Racional2 -> Racional2
simplificaRac2 (Rac num den) = (Rac (((signum num)*(signum den)) * (div (abs num) g)) (div (abs den) g)) where g=(gcd num den)

multRac2 :: Racional2 -> Racional2 -> Racional2
multRac2 (Rac n1 d1) (Rac n2 d2) = simplificaRac2 (Rac (n1*n2) (d1*d2))

divRac2 :: Racional2 -> Racional2 -> Racional2
divRac2 (Rac n1 d1) (Rac n2 d2) = simplificaRac2 (Rac (n1*d2) (n2*d1))

sumRac2 :: Racional2 -> Racional2 -> Racional2
sumRac2 (Rac n1 d1) (Rac n2 d2) = simplificaRac2 (Rac (n1*d2 + n2*d1) (d1*d2))

resRac2 :: Racional2 -> Racional2 -> Racional2
resRac2 r1 r2 = sumRac2 r1 (multRac2 (Rac (-1) 1) r2)

muestraRac2 :: Racional2 -> String 
muestraRac2 (Rac p q)
    | q==0 = "Indefinido"
    | mod p q == 0 = show (div p q)
    | otherwise = (show p) ++"/"++ (show q)

data Nat = Cero | Succ Nat 
    deriving (Eq, Show)
instance Num Nat where 
    n1 + n2 
        | n2 == Cero = n1 
        | otherwise = (Succ n1) + (predd n2)

predd :: Nat -> Nat 
predd Cero = Cero 
predd (Succ n) = n

