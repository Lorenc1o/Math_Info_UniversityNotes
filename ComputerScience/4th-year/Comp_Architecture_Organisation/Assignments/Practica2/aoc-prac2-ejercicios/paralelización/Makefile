
default: heat

all: heat heat-debug heat-icc

FILES_CPP=main.cpp heat.cpp
FILES_H=heat.h matrix.h 
SOURCES=$(FILES_CPP) $(FILES_H)

heat: $(SOURCES)
	g++ -std=c++11 -Wall -O3 -march=native -mtune=native -fopenmp $(FILES_CPP) -o$@

heat-icc: $(SOURCES)
	icc -std=c++11 -Wall -O2 -xCORE-AVX2 -qopenmp $(FILES_CPP) -o$@

heat-debug: $(SOURCES)
	g++ -std=c++11 -Wall -O0 -g -fopenmp $(FILES_CPP) -static -o$@

.PHONY: tests tests-icc tests-all
tests: heat
	./run-tests

tests-icc: heat-icc
	./run-tests ./heat-icc

tests-all: tests tests-icc

.PHONY: times times-icc times-all
times: heat
	./measure-times

times-icc: heat-icc
	./measure-times ./heat-icc

times-all: times times-icc


.PHONY: clean
clean:
	rm -f heat heat-icc heat-debug

