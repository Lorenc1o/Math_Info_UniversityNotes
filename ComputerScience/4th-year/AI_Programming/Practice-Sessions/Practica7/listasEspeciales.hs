module ListasEspeciales where

tamMax = 280

--a1
type ListaEspecial a = [a]

--a2
esCorta :: ListaEspecial a -> Bool 
esCorta s = (length s) <= tamMax

esLarga :: ListaEspecial a -> Bool 
esLarga s = not (esCorta s)

--a3
comienzaPor :: Eq a => a -> ListaEspecial a -> Bool 
comienzaPor c s = head s == c

terminaPor :: Eq a => a -> ListaEspecial a -> Bool
terminaPor c s = last s == c 

--a4
todosIguales :: Eq a => ListaEspecial a -> Bool 
todosIguales s = (length [i | i <- s, i == (head s)]) == (length s)

--a5
recortaLista :: ListaEspecial a -> ListaEspecial a 
recortaLista s = if (esCorta s) then s else (take tamMax s)


