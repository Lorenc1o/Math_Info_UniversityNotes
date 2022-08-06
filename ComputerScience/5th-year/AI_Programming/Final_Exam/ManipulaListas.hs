{-# OPTIONS_GHC -fno-warn-tabs #-}
--E2
module ManipulaListas (elecciones, particiones) where

import Data.List

--E1
type LisLis a = [[a]]

{-
(sublistas xs) es la lista de las sublistas de xs. Por ejemplo:
sublistas "bc" = ["","c","b","bc"]
sublistas "abc" = ["","c","b","bc","a","ac","ab","abc"]
-}

sublistas :: [a] -> LisLis a
sublistas [] = [[]]
sublistas (x:xs) = yss ++ map (x:) yss
		where yss = sublistas xs

{-
(elecciones xs) es la lista formada por todas las sublistas de xs en cualquier orden. Por ejemplo:
elecciones "abc" = ["","c","b","bc","cb","a","ac","ca","ab","ba","abc","bac","bca","acb","cab","cba"]
-}

elecciones :: [a] -> LisLis a
elecciones xs = concat (map permutations (sublistas xs))

{-
(particiones xs) es la lista que contiene las tuplas resultantes de dividir xs en dos listas no vac�as. Por ejemplo:
particiones "bcd" = [("b","cd"),("bc","d")]
particiones "abcd" = [("a","bcd"),("ab","cd"),("abc","d")]
-}

particiones :: [a] -> [([a],[a])]
particiones [] = []
particiones [_] = []
particiones (x:xs) = ([x],xs) : [(x:is,ds) | (is,ds) <- particiones xs]
