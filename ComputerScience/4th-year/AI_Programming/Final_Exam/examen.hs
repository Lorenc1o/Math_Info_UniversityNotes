{-# OPTIONS_GHC -fno-warn-tabs #-}
import Expresiones
import ManipulaListas
import Data.List

ejExpr :: Expr
ejExpr = Apl Mul e1 e2
          where e1 = Apl Sum (Num 1) (Num 50)
                e2 = Apl Res (Num 25) (Num 10)

--E1
numApariciones::Eq a=>a->[a]->Int
numApariciones e [] = 0
numApariciones e [x] = if(x==e) then 1 else 0
numApariciones e (x:cola) = if(x==e) then 1 + (numApariciones e cola) else numApariciones e cola

lis2set::Eq a=>[a]->[a]
lis2set [] = []
lis2set [x] = [x]
lis2set (x:cola) = if(elem x cola) then lis2set cola else [x] ++ (lis2set cola)  

solucion::Expr->[Int]->Int->Bool
solucion e ns n = if(na /= (length (numeros e)) || valor e == []) then False
                    else if(head (valor e)==n) then True
                    else False
                    where na = sum [numApariciones k ns | k<-(lis2set (numeros e))]
                          inters = [n | n <- (numeros e), (elem n ns)]

--tratando de mejorar la eficiencia
solucion2::Expr->[Int]->Int->Bool
solucion2 e ns n = if((numeros e) \\ ns /= [] || valor e == []) then False
                     else if(head (valor e)==n) then True
                     else False
                     where na = sum [numApariciones k ns | k<-(lis2set (numeros e))]
                           inters = [n | n <- (numeros e), (elem n ns)]

--E2
combina::Expr->Expr->[Expr]
combina e1 e2 = [Apl Sum e1 e2, Apl Res e1 e2, Apl Mul e1 e2, Apl Div e1 e2]

--E3
expresiones::[Int]->[Expr]
expresiones [] = []
expresiones [n] = [Num n]
expresiones [n1,n2] = combina (Num n1) (Num n2)
expresiones lista = concat [combina e1 e2 | (l1,l2) <- particiones lista, e1 <- (expresiones l1), e2 <- (expresiones l2)]  

--E4
soluciones::[Int]->Int->[Expr]
soluciones lista n = [ sol | l <- (elecciones lista), sol <- (expresiones l), solucion2 sol lista n]

--E5
imprimeSols::[Expr]->String
imprimeSols [] = ""
imprimeSols [e] = show e ++ "\n"
imprimeSols (e:cola) = show e ++ "\n" ++ imprimeSols cola

main = do 
        putStrLn "Introduce una lista de números separados por un espacio"
        line <- getLine
        let nums = map read (words line)
        putStrLn "Introduce el número objetivo"
        num <- getLine
        let obj = read num
        let sols = soluciones nums obj
        putStr (imprimeSols sols)