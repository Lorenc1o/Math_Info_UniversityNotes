
default: loops

all: loops

loops: loops.cpp
	icc -std=c++11 -Wall -O2 -xCORE-AVX2 -qopt-report -qopt-report-file=loops.cpp.optrpt $^ -o$@

.PHONY: clean
clean:
	rm -f loops loops.cpp.optrpt

