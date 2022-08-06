--Para tener siempre activados patrones n+k
{-# LANGUAGE NPlusKPatterns #-}

--Para evitar que aparezcan los warnings debidos a tabuladores
{-# OPTIONS_GHC -fno-warn-tabs #-} 

----------------------------------------------------
--------------------------DEFINICIONES DE FACTORIAL 
----------------------------------------------------
	

--- Mediante condicionales:

fac1 :: Integer -> Integer
fac1 n = if n==0 then 1 else n * fac1(n-1)  

--- Mediante guardas:

fac2 :: Integer -> Integer
fac2 n
   | n==0 = 1
   | n>0 = n * fac2(n-1)
   | n<0 = error "No se puede calcular el factorial de un numero negativo" 

	-- o bien (usando "otherwise" y operador * como función prefija):

fac3 :: Integer -> Integer
fac3 n
   | n==0 = 1
   | n<0 = error "No se puede calcular el factorial de un numero negativo"
   | otherwise = (*) n (fac3(n-1))

---Mediante guardas y definiciones locales:

fac4 :: Integer -> Integer
fac4 n
   | n==0 = 1
   | n<0 = error "No se puede calcular el factorial de un numero negativo"
   | otherwise = n * fac4'
	where fac4' = fac4 (n-1)


---Mediante encaje de patrones:

fac5 :: Integer -> Integer
fac5 0 = 1
fac5 n = n * fac5 (n-1)

---Mediante encaje de patrones n+k. OJO! La bandera -XNoNPlusKPatterns desactiva la opción de patrones n+k. Para activarla: -XNPlusKPatterns:

fac6 :: Integer -> Integer
fac6 0 = 1
fac6 (n+1) = (n+1) * fac6 n


---Mediante sentencias case:

fac7 :: Integer -> Integer
fac7 n = case n of
	0 -> 1
	otherwise -> n * fac7 (n-1)

---Mediante predefinidas:

fac8 :: Integer -> Integer
fac8 n = product [1..n]

---Mediante plegado:

fac9 :: Integer -> Integer
fac9 n = foldr (*) 1 [1..n] 
