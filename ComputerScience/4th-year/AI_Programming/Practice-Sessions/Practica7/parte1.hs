import C6
import Data.Char

main = do 
    putStr "Fichero entrada: "
    f <- getLine
    datos <- readFile f 
    putStr "Dato para percentil: "
    n <- getLine
    putStr n 
    putStr " está en el percentil "
    print (percentil (read n) (map read (words datos)))

listaDatos :: [Int] -> [Int]
listaDatos d = ordenarConArbol d

menores :: Int -> [Int] -> Int 
menores n d = length ([i | i <- d, i<=n])

percentil :: Int -> [Int] -> Float
percentil n d = (fromIntegral ((menores n (listaDatos d)) * 100 )) / (fromIntegral (length d))  
