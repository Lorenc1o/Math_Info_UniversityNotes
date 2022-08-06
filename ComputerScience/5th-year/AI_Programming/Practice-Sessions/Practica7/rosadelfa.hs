{-# OPTIONS_GHC -fno-warn-tabs #-}

module Rosadelfa where

data RAdelfa a = Nodo a [RAdelfa a]
    
instance (Show a)=> Show (RAdelfa a) where
	show (Nodo d xs) = shown 0 (Nodo d xs)

espacios :: Int -> String
espacios 0 = ""
espacios n = " " ++ espacios (n-1)

shown :: (Show a) => Int -> RAdelfa a -> String
shown n (Nodo c []) = espacios n ++ show c
shown n (Nodo c cola) = espacios n ++ show c ++ "\n" ++ concat (map ((++"\n").(shown (n+1))) cola)

podar :: RAdelfa a -> RAdelfa a
podar (Nodo c cola) = Nodo c (tail cola)

aplanar :: RAdelfa a -> [a]
aplanar (Nodo c cola) = c:concat (map aplanar cola)