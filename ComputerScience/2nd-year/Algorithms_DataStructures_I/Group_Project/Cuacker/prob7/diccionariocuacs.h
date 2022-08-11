#ifndef _DICCIONARIO_CUACS
#define _DICCIONARIO_CUACS
#include "HashTable.h"
using namespace std;

class DiccionarioCuacs{
    private:
        TablaHash tabla;
    public:
        void insertar(Cuac nuevo);
        void follow(string nombre);
        int numElem();
};

#endif