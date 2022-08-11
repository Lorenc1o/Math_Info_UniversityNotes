#!/bin/bash
realpath "$0" | cd
cd ./cpp/
echo "Generando casos..."
g++ generador_de_casos.cpp
./a.out > ../txt/casos_generados.txt
echo "Generando tabla para comparar criterios..."
g++ comparador_nodos_vs_criterios.cpp
./a.out < ../txt/casos_generados.txt > ../txt/tiempos_generados\(1\).txt
echo "Generando tabla para el criterio utilizado finalmente..."
g++ comparador_tiempo_vs_nodos.cpp
./a.out < ../txt/casos_generados.txt > ../txt/tiempos_generados\(2\).txt
cd ..