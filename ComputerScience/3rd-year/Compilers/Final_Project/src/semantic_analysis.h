#ifndef __SEMANTIC_ANALYSIS__
#define __SEMANTIC_ANALYSIS__
#include "listaSimbolos.h"

extern Lista l;
extern int errores_semanticos;
extern int yylineno;

// for function related analysis
void parse_function_declaration(char* name);
void end_function_declaration();
void parse_function_call(char* name);
void end_function_call();
void add_param();
void args_on();
PosicionLista args_off();

// for general analysis, including functions
PosicionLista insert_identifier(char* name, int type);
int insert_string(char* str);
PosicionLista check_identifier(char* name, int types);

// outputs data
void imprimirLS();

#endif

