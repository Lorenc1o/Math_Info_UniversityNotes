
default: binning

all: binning binning-debug binning-gcc

FILES_CPP=binning.cpp
FILES_H=binning.h
SOURCES=$(FILES_CPP) $(FILES_H)

binning: $(SOURCES)
	icpc -std=c++11 -Wall -O2 -xCORE-AVX2 -qopt-report=5 -qopt-report-file=$@.optrpt -qopenmp $(FILES_CPP) -o$@

binning-gcc: $(SOURCES)
	g++ -std=c++11 -Wall -O3 -march=native -mtune=native -fopt-info-all=$@.opt-info -fopenmp $(FILES_CPP) -static -o$@
# La versión de GCC de compiladorintel.inf.um.es es demasiado vieja y
# no soporta la generación de informes de optimización. Para usarla,
# se puede usar una de las siguientes dos líneas:
#	g++ -std=c++11 -Wall -O3 -ftree-vectorize -mavx2 -fopenmp $(FILES_CPP) -static -o$@
#	g++ -std=c++11 -Wall -O3 -march=native -mtune=native -fopenmp $(FILES_CPP) -static -o$@
#	g++ -std=c++11 -Wall -O3 -ftree-vectorize -mavx2 -fopt-info-all=$@.opt-info -fopenmp $(FILES_CPP) -static -o$@

binning-debug: $(SOURCES)
	g++ -std=c++11 -Wall -O0 -g -fopenmp $(FILES_CPP) -static -o$@

.PHONY: clean
clean:
	rm -f binning binning.optrpt binning-gcc binning-gcc.opt-info binning-debug
