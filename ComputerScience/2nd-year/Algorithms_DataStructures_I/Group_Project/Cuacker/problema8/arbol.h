#ifndef _ARBOL
#define _ARBOL
#include "cuac.h"

class Nodo{
    private:
        Nodo* derecho;
        Nodo* izquierdo;
        Cuac* elem;
        int altura;
    public:
        Nodo();
        ~Nodo();
    friend class Arbol;
};

class Arbol{
    private:
        Nodo* raiz;
    public:
        Arbol();
        ~Arbol();
        Nodo*& get_raiz(){
            return raiz;
        }
        void RSI(Nodo*& nodo);
        void RSD(Nodo*& nodo);
        void RDD(Nodo*& nodo);
        void RDI(Nodo*& nodo);
        int get_altura(Nodo* nodo);
        void insertar(Cuac *cuac, Nodo*& nodo);
        void last(int n,int &cont, Nodo* nodo);
        void date(Fecha &fecha1, Fecha &fecha2, int &cont, Nodo* nodo);
};

#endif