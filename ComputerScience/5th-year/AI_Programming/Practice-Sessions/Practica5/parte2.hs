import Data.Char 

type Mensaje = String 

minusculaAInt :: Char -> Int
minusculaAInt c = ord c - 97

mayusculaAInt :: Char -> Int 
mayusculaAInt c = ord c - 65

intAMinuscula :: Int -> Char
intAMinuscula n = chr ((mod n 26) + 97)

intAMayuscula :: Int -> Char 
intAMayuscula n = chr ((mod n 26) + 65)

desplaza :: Char -> Int -> Char 
desplaza c desp = if (ord c >= 97 && ord c <= 122) then intAMinuscula(minusculaAInt c + desp) else if (ord c >= 65 && ord c <= 90) then intAMayuscula(mayusculaAInt c + desp) else c

codifica :: String -> Int -> String
codifica str n = [desplaza a n | a <- str]

porcentaje :: Int -> Int -> Float
porcentaje n m = (fromIntegral n) / (fromIntegral m) * 100

sololetras :: String -> String 
sololetras str = [c | c<- str, (ord c >= 65 && ord c <= 90) || (ord c >= 97 && ord c <= 122)] 

ocurrencias :: Char -> String -> Int 
ocurrencias c str = length [k | k <- str, k==c]

frecuencias :: String -> [Float]
frecuencias str = [ fromIntegral ((ocurrencias c str)  + (ocurrencias cc str)) / m | (c, cc) <- [(intAMinuscula n, intAMayuscula n) | n <- [0..25]]] where m = length str

chiQuad :: [Float] -> [Float] -> Float 
chiQuad l1 l2 = sum [((x-y)^2)/y | (x,y) <- zip l1 l2]

rota :: String -> Int -> String 
rota str n = drop n str ++ take n str

tabla :: [Float]
tabla = [12.53, 1.42, 4.68, 5.86, 13.68, 0.69, 1.01, 
          0.70, 6.25, 0.44, 0.01,  4.97, 3.15, 6.71, 
          8.68, 2.51, 0.88, 6.87,  7.98, 4.63, 3.93, 
          0.90, 0.02, 0.22, 0.90,  0.52]

descifra :: String -> String 
descifra str = [desplaza c n | c <- str, n = ] --TODO

posiciones :: Eq a => a -> [a] -> [Int]
posiciones x xs = [i | (x',i) <- zip xs [0..], x == x']