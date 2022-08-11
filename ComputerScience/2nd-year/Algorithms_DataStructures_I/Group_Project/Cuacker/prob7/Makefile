a.out: fecha.o cuac.o HashTable.o diccionariocuacs.o main.o
	g++ fecha.o cuac.o HashTable.o diccionariocuacs.o main.o

fecha.o: fecha.cpp fecha.h
	g++ -c fecha.cpp

cuac.o: cuac.cpp cuac.h fecha.h
	g++ -c cuac.cpp

HashTable.o: HashTable.cpp HashTable.h cuac.h fecha.h
	g++ -c HashTable.cpp 

diccionariocuacs.o: diccionariocuacs.cpp diccionariocuacs.h HashTable.h cuac.h fecha.h
	g++ -c diccionariocuacs.cpp

main.o: main.cpp diccionariocuacs.h HashTable.h cuac.h fecha.h
	g++ -c main.cpp