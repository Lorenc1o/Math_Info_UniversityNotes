a.out: fecha.o cuac.o diccionariocuacs.o  main.o 
	g++ fecha.o cuac.o diccionariocuacs.o main.o

fecha.o: fecha.cpp fecha.h
	g++ -c fecha.cpp

cuac.o: cuac.cpp cuac.h fecha.h
	g++ -c cuac.cpp

diccionariocuacs.o: diccionariocuacs.cpp diccionariocuacs.h cuac.h fecha.h
	g++ -c diccionariocuacs.cpp

main.o: main.cpp diccionariocuacs.h cuac.h fecha.h
	g++ -c main.cpp