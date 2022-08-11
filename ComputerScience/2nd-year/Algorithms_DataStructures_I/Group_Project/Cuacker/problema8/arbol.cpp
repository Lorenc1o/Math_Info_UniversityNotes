#include "arbol.h"
#include <iostream>
#include <algorithm>
using namespace std;

Nodo::Nodo()
{
    derecho = NULL;
    izquierdo = NULL;
}
Nodo::~Nodo()
{
    delete izquierdo;
    delete derecho;
}

void Arbol::RSI(Nodo *&nodo)
{
    Nodo *aux = nodo->izquierdo;
    nodo->izquierdo = nodo->izquierdo->derecho;
    aux->derecho = nodo;
    nodo = aux;
    nodo->derecho->altura = 1 + max(get_altura(nodo->derecho->izquierdo), get_altura(nodo->derecho->izquierdo));
    nodo->altura = 1 + max(get_altura(nodo->derecho), get_altura(nodo->izquierdo));
}
void Arbol::RSD(Nodo *&nodo)
{
    Nodo *aux = nodo->derecho;
    nodo->derecho = nodo->derecho->izquierdo;
    aux->izquierdo = nodo;
    nodo = aux;
    nodo->izquierdo->altura = 1 + max(get_altura(nodo->izquierdo->izquierdo), get_altura(nodo->izquierdo->izquierdo));
    nodo->altura = 1 + max(get_altura(nodo->derecho), get_altura(nodo->izquierdo));
}
void Arbol::RDD(Nodo *&nodo)
{
    RSI(nodo->derecho);
    RSD(nodo);
}
void Arbol::RDI(Nodo *&nodo)
{
    RSD(nodo->izquierdo);
    RSI(nodo);
}
int Arbol::get_altura(Nodo *nodo)
{
    if (nodo == NULL)
        return -1;
    return nodo->altura;
}

Arbol::Arbol()
{
    raiz = NULL;
}
Arbol::~Arbol()
{
    delete raiz;
}

void Arbol::insertar(Cuac *cuac, Nodo *&nodo)
{
    if (nodo == NULL)
    {
        nodo = new Nodo();
        nodo->elem = cuac;
        nodo->izquierdo = nodo->derecho = NULL;
        nodo->altura = 0;
    }
    else if (!cuac->es_anterior(*nodo->elem))
    {
        insertar(cuac, nodo->izquierdo);
        if (get_altura(nodo->izquierdo) - get_altura(nodo->derecho) > 1)
        {
            if (!cuac->es_anterior(*(nodo->izquierdo->elem)))
                RSI(nodo);
            else
                RDI(nodo);
        }
        else
        {
            if (get_altura(nodo->izquierdo) > get_altura(nodo->derecho))
                nodo->altura = nodo->izquierdo->altura + 1;
            else
                nodo->altura = nodo->derecho->altura + 1;
        }
    }
    else
    {
        insertar(cuac, nodo->derecho);
        if (get_altura(nodo->derecho) - get_altura(nodo->izquierdo) > 1)
        {
            if (!cuac->es_anterior(*(nodo->derecho->elem)))
                RDD(nodo);
            else
                RSD(nodo);
        }
        else
        {
            if (get_altura(nodo->derecho) > get_altura(nodo->izquierdo))
                nodo->altura = nodo->derecho->altura + 1;
            else
                nodo->altura = nodo->izquierdo->altura + 1;
        }
    }
}

void Arbol::last(int n,int &cont, Nodo *nodo)
{
    if (nodo != NULL)
    {
        if (nodo->derecho != NULL)
        {
            last(n,cont,nodo->derecho);
        }
        if (cont < n)
        {
            cout << ++cont << ". ";
            nodo->elem->escribir();
        }
        if (cont < n)
        {
            last(n,cont,nodo->izquierdo);
        }
    }
}

void Arbol::date(Fecha &fecha1, Fecha &fecha2, int &cont, Nodo* nodo){
    if(nodo != NULL){
        Fecha fecha=nodo->elem->get_fecha();
        if(fecha.es_menor(fecha1)) date(fecha1, fecha2, cont, nodo->derecho);
        else if(fecha2.es_menor(fecha)) date(fecha1, fecha2, cont, nodo->izquierdo);
        else {
            date(fecha1, fecha2, cont, nodo->derecho);
            cout << ++cont << ". ";
            nodo->elem->escribir();
            date(fecha1, fecha2, cont, nodo->izquierdo);
        }
    }
}