minipascal : ./src/main.c ./src/minipascal.tab.c ./src/minipascal.c ./src/listaSimbolos.c ./src/semantic_analysis.c ./src/code_gen.c ./src/listaCodigo.c
	gcc ./src/main.c ./src/minipascal.tab.c ./src/minipascal.c ./src/listaSimbolos.c ./src/semantic_analysis.c ./src/code_gen.c ./src/listaCodigo.c -lfl -o $@

./src/minipascal.c : ./src/minipascal.l ./src/minipascal.tab.h
	flex -o $@ ./src/minipascal.l 

./src/minipascal.tab.c ./src/minipascal.tab.h : ./src/minipascal.y
	bison --defines=./src/minipascal.tab.h -o ./src/minipascal.tab.c ./src/minipascal.y -v

clean : 
	rm -f minipascal ./src/minipascal.tab.* ./src/minipascal.c ./src/minipascal.output

run : minipascal entrada.txt
	./minipascal entrada.txt
