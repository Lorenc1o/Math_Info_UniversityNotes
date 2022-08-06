{-# OPTIONS_GHC -fno-warn-tabs #-}
--E7
module Expresiones where

data Op = Sum | Res | Mul | Div

ops :: [Op]
ops = [Sum,Res,Mul,Div]


--1. Declarar Op como instancia de la clase Show
instance Show Op where
    show Sum = "+"
    show Res = "-"
    show Mul = "*"
    show Div = "/"

--2. Definir la funci�n valida 
valida::Op->Int->Int->Bool
valida Sum _ _ = True
valida Res x y = x>=y
valida Mul _ _ = True
valida Div x y = (y /= 0) && (mod x y == 0)

--3. Definir la funci�n aplica
aplica::Op->Int->Int->Int
aplica Sum x y = x+y
aplica Res x y = x-y
aplica Mul x y = x*y
aplica Div x y = div x y

data Expr = Num Int | Apl Op Expr Expr

--4. Declarar Expr como instancia de la clase Show
instance Show Expr where 
    show (Num n) = show n 
    show (Apl op (Num n1) (Num n2)) = (show n1) ++ (show op) ++ (show n2) 
    show (Apl op (Num n1) exp) = (show n1) ++ (show op) ++ "(" ++ (show exp) ++ ")"
    show (Apl op exp (Num n2)) = "(" ++ (show exp) ++ ")" ++ (show op) ++ (show n2)
    show (Apl op exp1 exp2) = "(" ++ (show exp1) ++ ")" ++ (show op) ++ "(" ++ (show exp2) ++ ")"

--5. Definir la funci�n numeros 
numeros::Expr->[Int]
numeros (Num n) = if (n>=0) then [n] else []
numeros (Apl op (Num n1) (Num n2)) = [n1,n2] 
numeros (Apl op (Num n1) exp) = [n1] ++ (numeros exp)
numeros (Apl op exp (Num n2)) = (numeros exp) ++ [n2]
numeros (Apl op exp1 exp2) = (numeros exp1) ++ (numeros exp2)

--6. Definir la funci�n valor
valor::Expr->[Int]
valor (Num n) = [n]
valor (Apl op (Num n1) (Num n2)) = if(valida op n1 n2) then [aplica op n1 n2] else [] 
valor (Apl op (Num n1) exp) = if(valor exp == []) then []
                                else if(valida op n1 x) then [aplica op n1 x] 
                                else []
                                where x = head (valor exp)
valor (Apl op exp (Num n2)) = if(valor exp == []) then []
                                else if(valida op x n2) then [aplica op x n2] 
                                else []
                                where x = head (valor exp)
valor (Apl op exp1 exp2) = if((valor exp1 == []) || (valor exp2 == [])) then []
                             else if(valida op x y) then [aplica op x y]
                             else []
                             where x = head (valor exp1)
                                   y = head (valor exp2)