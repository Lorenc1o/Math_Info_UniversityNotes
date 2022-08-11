#!/bin/bash
realpath "$0" | cd
cd ./cpp/
g++ generador_de_casos.cpp
echo "Generando casos... Esto puede tardar un rato"
#./a.out > ../txt/casos_generados.txt
g++ generador_de_tiempo.cpp
echo "Generando tiempos..."
./a.out < ../txt/casos_generados.txt > ../txt/tiempos_generados.txt
cd ..