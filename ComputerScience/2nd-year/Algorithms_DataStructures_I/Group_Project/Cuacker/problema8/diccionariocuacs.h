#ifndef _DICCIONARIO_CUACS
#define _DICCIONARIO_CUACS
#include "tablahash.h"
#include "cuac.h"
#include "arbol.h"
using namespace std;

class DiccionarioCuacs{
    private:
        TablaHash tabla;
        Arbol arbol;
    public:
        void insertar(Cuac nuevo);
        void follow(string nombre);
        void last(int n);
        int numElem(){
            return tabla.numelem();
        }
        void date(Fecha fecha1, Fecha fecha2);
};

#endif