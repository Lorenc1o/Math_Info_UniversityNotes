#ifndef _DICCIONARIO_CUACS
#define _DICCIONARIO_CUACS
#include <list>
#include "cuac.h"
using namespace std;

class DiccionarioCuacs{
    private:
        TablaHash tabla;
    public:
        DiccionarioCuacs();
        void insertar(Cuac nuevo);
        void last(int N);
        void follow(string nombre);
        void date (Fecha f1, Fecha f2);
        int numElem(){
            return contador;
        }
};

#endif