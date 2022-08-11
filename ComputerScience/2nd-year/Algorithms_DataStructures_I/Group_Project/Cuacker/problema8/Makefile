a.out: fecha.o cuac.o tablahash.o arbol.o diccionariocuacs.o main.o
	g++ fecha.o cuac.o tablahash.o arbol.o diccionariocuacs.o main.o

fecha.o: fecha.cpp fecha.h
	g++ -c fecha.cpp

cuac.o: cuac.cpp cuac.h fecha.h
	g++ -c cuac.cpp

tablahash.o: tablahash.cpp tablahash.h cuac.h fecha.h
	g++ -c tablahash.cpp

arbol.o: arbol.cpp arbol.h cuac.h fecha.h
	g++ -c arbol.cpp

diccionariocuacs.o: diccionariocuacs.cpp diccionariocuacs.h arbol.h tablahash.h cuac.h fecha.h
	g++ -c diccionariocuacs.cpp

main.o: main.cpp diccionariocuacs.h arbol.h tablahash.h cuac.h fecha.h
	g++ -c main.cpp