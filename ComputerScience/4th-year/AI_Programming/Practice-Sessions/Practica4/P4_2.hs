import parte1
--1
-- cAplica :: (a -> [b]) -> [a] -> [b]

--2
rotalista :: Eq a -> [a] -> [[a]]
rotalista [] = []
rotalista [x] = [[x]]
rotalista (x:cola) = []