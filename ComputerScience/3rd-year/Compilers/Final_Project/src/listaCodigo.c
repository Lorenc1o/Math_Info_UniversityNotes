#include "listaCodigo.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct PosicionListaCRep {
    Operacion dato;
    struct PosicionListaCRep *sig;
};

struct ListaCRep {
    PosicionListaC cabecera;
    PosicionListaC ultimo;
    int n;
    char *res;
};

typedef struct PosicionListaCRep *NodoPtr;

ListaC creaLC() {
    ListaC nueva = malloc(sizeof(struct ListaCRep));
    nueva->cabecera = malloc(sizeof(struct PosicionListaCRep));
    nueva->cabecera->sig = NULL;
    nueva->ultimo = nueva->cabecera;
    nueva->n = 0;
    nueva->res = NULL;
    return nueva;
}

void liberaLC(ListaC codigo) {
    if (codigo == NULL) return;
    while (codigo->cabecera != NULL) {
        NodoPtr borrar = codigo->cabecera;
        codigo->cabecera = borrar->sig;
        free(borrar);
    }
    free(codigo);
}

void insertaLC(ListaC codigo, PosicionListaC p, Operacion o) {
    NodoPtr nuevo = malloc(sizeof(struct PosicionListaCRep));
    nuevo->dato = o;
    nuevo->sig = p->sig;
    p->sig = nuevo;
    if (codigo->ultimo == p) {
        codigo->ultimo = nuevo;
    }
    (codigo->n)++;
}

Operacion recuperaLC(ListaC codigo, PosicionListaC p) {
    assert(p != codigo->ultimo);
    return p->sig->dato;
}

PosicionListaC buscaLC(ListaC codigo, PosicionListaC p, char *clave,
                       Campo campo) {
    NodoPtr aux = p;
    char *info;
    while (aux->sig != NULL) {
        switch (campo) {
            case OPERACION:
                info = aux->sig->dato.op;
                break;
            case ARGUMENTO1:
                info = aux->sig->dato.arg1;
                break;
            case ARGUMENTO2:
                info = aux->sig->dato.arg2;
                break;
            case RESULTADO:
                info = aux->sig->dato.res;
                break;
        }
        if (info != NULL && !strcmp(info, clave)) break;
        aux = aux->sig;
    }
    return aux;
}

void asignaLC(ListaC codigo, PosicionListaC p, Operacion o) {
    assert(p != codigo->ultimo);
    p->sig->dato = o;
}

int longitudLC(ListaC codigo) { return codigo->n; }

PosicionListaC inicioLC(ListaC codigo) { return codigo->cabecera; }

PosicionListaC finalLC(ListaC codigo) { return codigo->ultimo; }

void concatenaLC(ListaC codigo1, ListaC codigo2) {
    NodoPtr aux = codigo2->cabecera;
    while (aux->sig != NULL) {
        insertaLC(codigo1, finalLC(codigo1), aux->sig->dato);
        aux = aux->sig;
    }
}

PosicionListaC siguienteLC(ListaC codigo, PosicionListaC p) {
    assert(p != codigo->ultimo);
    return p->sig;
}

void guardaResLC(ListaC codigo, char *res) { codigo->res = res; }

/* Recupera el registro resultado de una lista de codigo */
char *recuperaResLC(ListaC codigo) { return codigo->res; }
