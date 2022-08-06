import ListaPar 

--b1
type ListaChr = ListaP2 Char

--b2
listaAcadena :: ListaChr -> String 
listaAcadena [] = ""
listaAcadena ((n,c):cola) = show n ++ [c] ++ (listaAcadena cola)

--b3
cadenaComprimida :: String -> String 
cadenaComprimida s = listaAcadena (comprimida s)

--b4
cadenaAlista :: String -> ListaChr
cadenaAlista "" = []
cadenaAlista s = [(read (takeWhile (':' >) s),head (dropWhile (':' >) s))] ++ cadenaAlista (tail (dropWhile (':' >) s))

--b5
cadenaExpandida :: String -> String 
cadenaExpandida s = expandida (cadenaAlista s)

--b6
