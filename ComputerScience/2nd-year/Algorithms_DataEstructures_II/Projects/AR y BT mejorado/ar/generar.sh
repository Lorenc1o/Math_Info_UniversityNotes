#!/bin/bash
realpath "$0" | cd
cd ./cpp/
g++ generador_de_casos.cpp
echo "Generando casos... Esto puede tardar un rato"
echo "Generando casos promedios"
echo 1 | ./a.out > ../txt/caso_promedio.txt
echo "Generando casos mejores"
echo 2 | ./a.out > ../txt/caso_mejor.txt
echo "Generando casos peores"
echo 3 | ./a.out > ../txt/caso_peor.txt
g++ generador_de_tiempo.cpp
echo "Generando tiempos..."
echo "Generando tiempos para el caso promedio"
./a.out < ../txt/caso_promedio.txt > ../txt/tiempos_caso_promedio.html
echo "Generando tiempos para el caso mejor"
./a.out < ../txt/caso_mejor.txt > ../txt/tiempos_caso_mejor.html
echo "Generando tiempos para el caso peor"
./a.out < ../txt/caso_peor.txt > ../txt/tiempos_caso_peor.html
cd ..