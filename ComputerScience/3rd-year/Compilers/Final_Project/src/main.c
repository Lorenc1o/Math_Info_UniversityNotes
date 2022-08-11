#include <stdio.h>
#include <stdlib.h>

extern int yyparse();
extern FILE *yyin;
extern int errores_semanticos, errores_sintacticos, errores_lexicos;
FILE *fich;

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Uso: %s fichero\n", argv[0]);
    }
    if ((fich = fopen(argv[1], "r")) == NULL) {
        printf("***ERROR, no puedo abrir el fichero\n");
        exit(1);
    }
    yyin = fich;

    int resultado = yyparse();
    if (errores_lexicos + errores_semanticos + errores_sintacticos != 0) {
        printf("Errores léxicos: %d\n", errores_lexicos);
        printf("Errores sintácticos: %d\n", errores_sintacticos);
        printf("Errores semánticos: %d\n", errores_semanticos);
    }

    fclose(fich);
    return 0;
}
