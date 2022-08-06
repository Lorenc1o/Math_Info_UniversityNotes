
default: all

EXECS=helloflops1 helloflops2 hellomem copy helloflops1-O0 helloflops1-O2-noavx2 helloflops1-O2 helloflops1-O2-novec

all: $(EXECS)

helloflops2: helloflops2.c
	icc -Wall -O2 -qopenmp -xCORE-AVX2 -o $@ $<

hellomem: hellomem.c
	icc -Wall -O2 -qopenmp -xCORE-AVX2 -o $@ $<

copy: copy.cc
	icpc -Wall -O2 -qopenmp -xCORE-AVX2 -o $@ $<

helloflops1-O0: helloflops1.c
	icc -Wall -O0 -o $@ $<

helloflops1-O2-noavx2: helloflops1.c
	icc -Wall -O2 -o $@ $<

helloflops1-O2: helloflops1.c
	icc -Wall -O2 -xCORE-AVX2 -o $@ $<

helloflops1-O2-novec: helloflops1.c
	icc -Wall -O2 -xCORE-AVX2 -no-vec -o $@ $<

%: %.c
	icc -Wall -O2 -xCORE-AVX2 -o $@ $<

%: %.cc
	icpc -Wall -O2 -xCORE-AVX2 -o $@ $<

.PHONY: clean
clean:
	rm -f $(EXECS)


run: all
	for i in $(EXECS) ; do \
		echo ./$$i ;\
		./$$i ;\
	done
