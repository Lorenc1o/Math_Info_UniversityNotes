module ListaPar where

--a1
data ListaP a = LP [(Int, a)]

--a2
instance Show a => Show (ListaP a) where
    show (LP []) = ""
    show (LP [(n,c)]) = show n ++ "->" ++ show c 
    show (LP ((n,c):cola)) = show (LP [(n,c)]) ++ "\n" ++ show (LP cola)

--a3
type ListaP2 a = [(Int, a)]

--a4
comprimida :: Eq a => [a] -> ListaP2 a
comprimida [] = []
comprimida (a:cola) = [(1+ length (takeWhile (a ==) cola), a)] ++ comprimida (dropWhile (a ==) cola)

--a5
expandida :: ListaP2 a -> [a]
expandida [] = []
expandida ((n,c):cola) = replicate n c ++ expandida cola