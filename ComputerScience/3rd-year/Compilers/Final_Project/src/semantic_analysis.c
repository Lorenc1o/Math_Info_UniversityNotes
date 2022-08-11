#include "semantic_analysis.h"

#include <stdio.h>
#include <string.h>
#define BUFFSIZE 1024
// Para errores
#define REDECLARATION 0
#define NOTDECLARED 1
#define WRONGTYPE 2
#define FUNCARGNAME 3
#define NOTAFUNCTION 4
#define TOOMANYARGS 5
#define WRONGPARAMNUMBER 6

//
// DATA
//

char* errores[] = {"redeclarado",
                   "no declarado",
                   "es constante",
                   "es el nombre de la función",
                   "no es una función",
                   "tiene más de 4 argumentos",
                   "llamada con número incorrecto de parámetros"};

char buffer[BUFFSIZE];
extern int errores_semanticos;
int parsing_func = 0;
int parsing_args = 0;
int str_counter = 1;
int count_args;
PosicionLista current_fd = NULL;
PosicionLista current_fc = NULL;
Lista aux = NULL;

// error function
void throw_semantic_error(char* arg, int code) {
    printf("Error en la línea %d: %s %s\n", yylineno, arg, errores[code]);
    errores_semanticos++;
}

// insert a symbol in a list
PosicionLista insert_ls(char* name, int type, int value, Lista list) {
    PosicionLista p = buscaLS(list, name);
    if (p != finalLS(list)) return NULL;
    Simbolo sim;
    sim.nombre = strdup(name);
    sim.valor = value;
    sim.tipo = type;
    insertaLS(list, finalLS(list), sim);
    return finalLS(list);
}

// insert a symbol in the programs list
PosicionLista insert(char* name, int type, int value) {
    return insert_ls(name, type, value, l);
}

// start function parsing mode
void parse_function_declaration(char* name) {
    parsing_func = 1;  // parsing function now
    PosicionLista p = buscaLS(l, name);
    if (p != finalLS(l)) {
        // function redeclared
        throw_semantic_error(name, REDECLARATION);
        return;
    }
    aux = creaLS();
    current_fd = insert_ls(name, FUNCION, 0, aux);
}

// end function parsing mode
void end_function_declaration() {
    parsing_func = 0;
    current_fd = NULL;
}

// start argument parsing
void args_on() {
    parsing_args = 1;
    count_args = 0;
}

// end argument parsing
PosicionLista args_off() {
    parsing_args = 0;
    if (current_fd != NULL) {
        // if more arguments than possible, do not add to list
        if (count_args > 4) {
            throw_semantic_error(current_fd->dato.nombre, TOOMANYARGS);
            liberaLS(aux);
            current_fd = NULL;
            fflush(NULL);
            aux = NULL;
            return NULL;
        }
        current_fd->dato.valor = count_args;
        concatenaLS(l, aux);
        aux = NULL;
        return current_fd;
    }
    return NULL;
}

// This method searches for FUNCTION in ls
PosicionLista get_function(char* arg) {
    PosicionLista p = buscaLS(l, arg);
    if (p == finalLS(l)) {
        throw_semantic_error(arg, NOTDECLARED);
        return NULL;
    }
    if (p->sig->dato.tipo != FUNCION) {
        throw_semantic_error(arg, NOTAFUNCTION);
        return NULL;
    }
    return p->sig;
}

void parse_function_call(char* name) {
    PosicionLista p = get_function(name);
    if (p != NULL) current_fc = p;
    count_args = 0;
}

void add_param() { count_args++; }

void end_function_call() {
    if (current_fc != NULL)
        if (count_args != current_fc->dato.valor)
            throw_semantic_error(current_fc->dato.nombre, WRONGPARAMNUMBER);
    current_fc = NULL;
}

PosicionLista insert_identifier(char* name, int type) {
    char* original_name = name;
    PosicionLista ret;
    if (parsing_func) {
        if (current_fd == NULL) return NULL;
        if (parsing_args) count_args++;
        if (strcmp(current_fd->dato.nombre, name) == 0) {
            // nombre del identificador coincide con nombre de función
            throw_semantic_error(name, FUNCARGNAME);
            return NULL;
        }
        sprintf(buffer, "%s.%s", current_fd->dato.nombre, name);
        name = buffer;
        if (parsing_args) {
            PosicionLista p = buscaLS(l, name);
            if (p != finalLS(l) ||
                (ret = insert_ls(name, ARGUMENTO, count_args - 1, aux)) ==
                    NULL) {
                throw_semantic_error(original_name, REDECLARATION);
                return NULL;
            }
            return ret;
        }
    }
    if ((ret = insert(name, type, 0)) == NULL) {
        throw_semantic_error(original_name, REDECLARATION);
        return NULL;
    }
    return ret;
}

int insert_string(char* str) {
    PosicionLista p = buscaLS(l, str);
    if (p == finalLS(l)) {
        Simbolo aux;
        aux.nombre = strdup(str);
        aux.valor = str_counter++;
        aux.tipo = CADENA;
        insertaLS(l, finalLS(l), aux);
        return aux.valor;
    } else
        return recuperaLS(l, p).valor;
}

// This method searches for VARIABLE, CONSTANT or ARGUMENT in LS
PosicionLista check_identifier(char* name, int types) {
    char* original_name = name;
    // If in function, add prefix
    if (parsing_func) {
        if (current_fd == NULL) return NULL;
        if (strcmp(current_fd->dato.nombre, name) == 0) {
            // están accediendo a lo que guarda la función
            // no hay ningún error
            return current_fd;
        }
        sprintf(buffer, "%s.%s", current_fd->dato.nombre, name);
        name = buffer;
    }
    // Search for identifier
    PosicionLista p = buscaLS(l, name);
    if (p == finalLS(l)) {
        // If we didn't find it, semantic error, not declared
        throw_semantic_error(name, NOTDECLARED);
        return NULL;
    } else {
        Simbolo sim = recuperaLS(l, p);
        if ((types & sim.tipo) == 0) {
            throw_semantic_error(name, WRONGTYPE);
            return NULL;
        }
    }
    return p->sig;
}

void imprimirLS() {
    // Recorrido y generación de .data
    printf("##################\n");
    printf("# Seccion de datos\n");
    printf("\t.data\n");
    PosicionLista p = inicioLS(l);
    while (p != finalLS(l)) {
        Simbolo aux = recuperaLS(l, p);
        // Volcar info del símbolo
        if (aux.tipo == CADENA)
            printf("$str%d: \n\t.asciiz %s\n", aux.valor, aux.nombre);
        p = siguienteLS(l, p);
    }
    p = inicioLS(l);
    while (p != finalLS(l)) {
        Simbolo aux = recuperaLS(l, p);
        // Volcar info del símbolo
        if (aux.tipo & (CONSTANTE | VARIABLE | ARGUMENTO))
            printf("_%s: \n\t.word 0\n", aux.nombre);
        p = siguienteLS(l, p);
    }
}
