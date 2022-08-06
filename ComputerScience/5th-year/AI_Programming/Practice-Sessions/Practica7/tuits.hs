import ListasEspeciales (ListaEspecial,recortaLista,comienzaPor)

--b1
type Dia = Int
type Mes = Int 
type Ano = Int 

type Fecha = (Dia, Mes, Ano)

type Identidad = ListaEspecial Char
type Mensaje = ListaEspecial Char 
type Hashtag = ListaEspecial Char 

--b2
esFecha :: Fecha -> Bool 
esFecha (d, m ,a) = if (1<=d && d<=31 && 1<=m && m<=12 && 1<=a && a<=9999) then True else False

esIdentidad :: Identidad -> Bool 
esIdentidad s = if (comienzaPor '@' s) then True else False 

esHashtag :: Hashtag -> Bool 
esHashtag s = if(comienzaPor '#' s) then True else False 

--b3
data Tuit = T {f::Fecha, id::Identidad, m::Mensaje}

unTuit :: Tuit
unTuit = T (18,1,1892) "@cinemasmusic_" "#TalDiaComoHoy hace 127 a\241os nac\237a Norvell Hardy (Harlem, Georgia, 18 de enero de 1892-Los Angeles, California, 7 de agosto de 1957), m\225s conocido como #OliverHardy. Un genio del humor. Por siempre el Gordo junto a su amigo Stan Laurel. #BornOnThisDay"

esTuit :: Tuit -> Bool 
esTuit (T f id m) = (esFecha f) && (esIdentidad id)
instance Show Tuit where 
    show (T (d, ms, a) id m) = if esTuit (T (d, ms, a) id m) then 
        id ++
        " (" ++ show d ++ "/" ++ show ms ++ "/" ++ show a ++ ")" ++ ": " ++
        recortaLista m ++ "\n" else error "Formato incorrecto"

type Tuits = [Tuit]

--b4
identidades :: Tuits -> [Identidad]
identidades t = [id | (T f id m) <- t]

--b5
mensajes :: Tuits -> [Mensaje]
mensajes t = [m | (T f id m) <- t]

--b6
numTuits :: Identidad -> Tuits -> Int 
numTuits id t = length [(T f i m) | (T f i m) <- t, i==id]

type perfil = (Identidad, Int)
instance 

tuiteros :: Tuits -> [(Identidad, Int)]
tuiteros t = [(i, numTuits i t) | i <- identidades t]

masTuitero :: (Identidad, Int) -> (Identidad, Int) -> (Identidad, Int)
masTuitero (i1, n1) (i2, n2) = if(n1>=n2) then (i1, n1) else (i2, n2)

ordenarTuiteros :: [(Identidad, Int)] -> [(Identidad, Int)]
ordenarTuiteros (x:y:cola) = 

masActivo :: Tuits -> Identidad
masActivo t = 
