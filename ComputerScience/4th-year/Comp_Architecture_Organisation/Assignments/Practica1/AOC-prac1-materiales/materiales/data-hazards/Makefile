
default: execs

all: execs-gcc execs 

SUMAFLOPS=$(wildcard sumaflops*.c)

.PHONY: execs
execs: $(SUMAFLOPS:.c=)

.PHONY: execs-gcc
execs-gcc: $(SUMAFLOPS:.c=-gcc)

%: %.c
	icc -Wall -O2 -xCORE-AVX2 -o $@ $<

# La versión de gcc en compiladorintel.inf.um.es es muy antigua y no soporta skylake-avx512 (por lo que dificilmente puede vectorizar bien).
# En una versión más moderna, la regla siguiente debería ser:
#	gcc -Wall -O2 -ftree-vectorize -march=skylake-avx512 -o $@ $<
%-gcc: %.c
	gcc -Wall -O2 -ftree-vectorize -o $@ $<

.PHONY: clean
clean:
	rm -f $(SUMAFLOPS:.c=) $(SUMAFLOPS:.c=-gcc)


run: execs
	for i in $(SUMAFLOPS:.c=) ; do \
		echo ./$$i ;\
		./$$i ;\
	done

run-gcc: execs-gcc
	for i in $(SUMAFLOPS:.c=-gcc) ; do \
		echo ./$$i ;\
		./$$i ;\
	done

run-all: run run-gcc
