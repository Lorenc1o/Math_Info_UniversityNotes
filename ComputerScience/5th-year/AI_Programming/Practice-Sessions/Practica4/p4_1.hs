{-# OPTIONS_GHC -fno-warn-tabs #-}

module parte1 where

ordenada :: Ord a => [a] -> Bool
ordenada [] = True
ordenada [_] = True 
ordenada (x:y:cola) = (x <= y) && (ordenada (y:cola))

borrar :: Eq a => a -> [a] -> [a] 
borrar x [] = []
borrar x (y:cola) = if (x==y) then (cola) else [y]++(borrar x (cola))

insertar :: Ord a => a -> [a] -> [a]
insertar e [] = [e]
insertar e [x] = if(e<=x) then [e]++[x] else [x]++[e]
insertar e (x:cola) = if(e<=x) then [e]++(x:cola) else [x] ++ insertar e (cola)

ordInsercion :: Ord a => [a] -> [a]
ordInsercion [] = []
ordInsercion [x] = [x]
ordInsercion (x:cola) = insertar x (ordInsercion cola)

minimo :: Ord a => [a] -> a 
minimo [] = error "La lista es vacía"
minimo lista = head (ordInsercion lista)

mezcla :: Ord a => [a] -> [a] -> [a]
mezcla l1 l2 = ordInsercion (l1++l2)

mitades :: [a] -> ([a],[a])
mitades lista = (take long lista, drop long lista) where long = div (length lista) 2

ordMezcla :: Ord a => [a] -> [a]
ordMezcla [] = []
ordMezcla [a] = [a]
ordMezcla lista = mezcla (ordMezcla l1) (ordMezcla l2) where (l1,l2) = mitades lista

pertenece :: Eq a => a -> [a] -> Bool 
pertenece x [] = False 
pertenece x (y:cola) = if(x==y) then True else pertenece x (cola)

esPermutacion :: Eq a => [a] -> [a] -> Bool
esPermutacion [] [] = True 
esPermutacion [x] [y] = x==y
esPermutacion (x:cola) lista = esPermutacion (cola) (borrar x lista)

