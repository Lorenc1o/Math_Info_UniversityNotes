#include "listaSimbolos.h"

#include <assert.h>
#include <stdlib.h>
#include <string.h>

typedef struct PosicionListaRep *NodoPtr;

Lista creaLS() {
    Lista nueva = malloc(sizeof(struct ListaRep));
    nueva->cabecera = malloc(sizeof(struct PosicionListaRep));
    nueva->cabecera->sig = NULL;
    nueva->ultimo = nueva->cabecera;
    nueva->n = 0;
    return nueva;
}

void liberaLS(Lista lista) {
    while (lista->cabecera != NULL) {
        NodoPtr borrar = lista->cabecera;
        lista->cabecera = borrar->sig;
        free(borrar);
    }
    free(lista);
}

void insertaLS(Lista lista, PosicionLista p, Simbolo s) {
    NodoPtr nuevo = malloc(sizeof(struct PosicionListaRep));
    nuevo->dato = s;
    nuevo->sig = p->sig;
    p->sig = nuevo;
    if (lista->ultimo == p) {
        lista->ultimo = nuevo;
    }
    (lista->n)++;
}

void suprimeLS(Lista lista, PosicionLista p) {
    assert(p != lista->ultimo);
    NodoPtr borrar = p->sig;
    p->sig = borrar->sig;
    if (lista->ultimo == borrar) {
        lista->ultimo = p;
    }
    free(borrar);
    (lista->n)--;
}

Simbolo recuperaLS(Lista lista, PosicionLista p) {
    assert(p != lista->ultimo);
    return p->sig->dato;
}

PosicionLista buscaLS(Lista lista, char *nombre) {
    NodoPtr aux = lista->cabecera;
    while (aux->sig != NULL && strcmp(aux->sig->dato.nombre, nombre) != 0) {
        aux = aux->sig;
    }
    return aux;
}

void asignaLS(Lista lista, PosicionLista p, Simbolo s) {
    assert(p != lista->ultimo);
    p->sig->dato = s;
}

int longitudLS(Lista lista) { return lista->n; }

PosicionLista inicioLS(Lista lista) { return lista->cabecera; }

PosicionLista finalLS(Lista lista) { return lista->ultimo; }

PosicionLista siguienteLS(Lista lista, PosicionLista p) {
    assert(p != lista->ultimo);
    return p->sig;
}

void concatenaLS(Lista l1, Lista l2) {
    if (l2->n == 0) {
        free(l2);
        return;
    }
    l1->ultimo->sig = l2->cabecera->sig;
    l1->ultimo = l2->ultimo;
    l1->n += l2->n;
    free(l2);
}
