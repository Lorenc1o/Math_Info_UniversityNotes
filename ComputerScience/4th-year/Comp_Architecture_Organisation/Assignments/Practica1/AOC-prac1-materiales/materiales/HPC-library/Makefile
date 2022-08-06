
default: all

EXECS=MMultSeq2D MMult2Seq2D MMultmkl2D gen

all: $(EXECS)

MMultSeq2D: MMultSeq2D.c
	icc -Wall -O2 -xCORE-AVX2 -o MMult2Seq2D MMult2Seq2D.c

MMult2Seq2D: MMult2Seq2D.c
	icc -Wall -O2 -xCORE-AVX2 -o MMult2Seq2D MMult2Seq2D.c

MMultmkl2D: MMultmkl2D.cc
	icpc -Wall -O2 -qopenmp -xCORE-AVX2 -mkl -o $@ $<

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
